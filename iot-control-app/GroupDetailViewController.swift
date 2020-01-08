//
//  GroupDetailViewController.swift
//  iot-control-app
//
//  Created by Matt Callaway on 06/07/2019.
//  Copyright © 2019 Matt Callaway. All rights reserved.
//

import UIKit

class GroupDetailViewController: UIViewController, UIToolbarDelegate, UserListContainer, DeviceListContainer, AttributeListContainer {
    
    
    private let uc = UserController()

    @IBOutlet weak var segmentControl: UISegmentedControl!
    @IBOutlet weak var toolbar: UIToolbar!
    @IBOutlet weak var addButton: UIBarButtonItem!
    @IBOutlet weak var viewContainer: UIView!
    
	var group : Group?
    var groupController : GroupController!
    
    private var usersListView : UserListTableViewController!
    private var attributesListView : AttributeListTableViewController!
    private var devicesListView : DevicesListTableViewController!
    
    private var selectedUser : User?
    private var selectedDevice : Device?
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationController?.navigationBar.setValue("true", forKey: "hidesShadow")
        
        guard let group = self.group else {
            fatalError("No group passed to view controller to show!")
        }
        
        
        groupController = GroupController(group: group)
        
        usersListView = UserListTableViewController()
        usersListView.setCallbackView(cb: self)
        
        attributesListView = AttributeListTableViewController()
        attributesListView.setCallbackView(cb: self)
        
        devicesListView = DevicesListTableViewController()
        devicesListView.setCallbackView(cb: self)
        
        self.navigationItem.title = "Group \(group.id): \(group.name)"
        
        reloadRelevantList(section: segmentControl.selectedSegmentIndex)
        
        viewContainer.addSubview(usersListView.view)
        viewContainer.addSubview(attributesListView.view)
        viewContainer.addSubview(devicesListView.view)
        viewContainer.isUserInteractionEnabled = true
        
        // Set default subview is the list of users (for now..)
        viewContainer.bringSubviewToFront(usersListView.view)
        
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        self.navigationController?.navigationBar.setValue("false", forKey: "hidesShadow")
    }
    
    func loadUsers() {
        groupController?.getUsers {
            self.usersListView.setContent(users: self.groupController.users)
        }
    }
    
    func loadAttributes() {
        groupController?.getAttributes {
            self.attributesListView.setContent(attributes: self.groupController.attributes)
        }
    }
    
    func loadDevices() {
        groupController?.getDevices {
            self.devicesListView.setContent(devices: self.groupController.devices)
        }
    }
    
    // Called when the userList view received a tap on a specific user
    func userSelected(user: User) {
        selectedUser = user
        self.performSegue(withIdentifier: "showUserDetail", sender: self)
    }
    
    // Called when the device list received a tap on a specific device
    func deviceSelected(device: Device) {
        selectedDevice = device
        self.performSegue(withIdentifier: "showDeviceDetail", sender: self)
    }
    
    func attributeSelected(attribute: Attribute) {

    }
    

    @IBAction func segmentChanged(_ sender: UISegmentedControl) {
        reloadRelevantList(section: sender.selectedSegmentIndex)
        switch sender.selectedSegmentIndex {
        case 0:
            addButton.isEnabled = true
            viewContainer.bringSubviewToFront(devicesListView.view)
            break
        case 1:
            addButton.isEnabled = true
            viewContainer.bringSubviewToFront(usersListView.view)
            break
        case 2:
            addButton.isEnabled = group?.admin == UserController.getUserID()
            viewContainer.bringSubviewToFront(attributesListView.view)
            break
        default:
            break
        }
    }
    
    @IBAction func addButtonClicked(_ sender: Any) {
        // The add button in this view acts contextually according to which segmented view the user is looking at out of users, devices, attributes
        switch(segmentControl.selectedSegmentIndex) {
        case 0:
            // Devices segment is in view
            performSegue(withIdentifier: "addNewDevice", sender: self)
            break
        case 1:
            // Users segment is in view
            performSegue(withIdentifier: "addNewUser", sender: self)
            break
        case 2:
            // Attributes segment is in view
            performSegue(withIdentifier: "createNewAttribute", sender: self)
            break
        default:
            fatalError("Add button clicked but unexpected segment ID!")
        }
    }
    
    @IBAction func refreshClicked(_ sender: Any) {
        reloadRelevantList(section: segmentControl.selectedSegmentIndex)
    }
    
    
    // MARK: - Navigation
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        super.prepare(for: segue, sender: sender)
        switch(segue.identifier ?? "") {
        case "showUserDetail":
            print("Group detail preparing for segue to user detail")
            guard let userDetailViewController = segue.destination as? UserDetailViewController else {
                fatalError("Unexpected segue destination \(segue.destination)")
            }
            guard let selectedUser = self.selectedUser else {
                fatalError("No selected user while performing showUserDetail view segue")
            }
            userDetailViewController.groupController = self.groupController
            userDetailViewController.user = selectedUser
        case "showDeviceDetail":
            print("Group detail preparing for segue to device detail")
            guard let deviceDetailViewController = segue.destination as? DeviceViewController else {
                fatalError("Unexpected segue destination \(segue.destination)")
            }
            guard let selectedDevice = self.selectedDevice else {
                fatalError("No selected device while performing showDeviceDetail view segue")
            }
            deviceDetailViewController.groupController = self.groupController
            deviceDetailViewController.device = selectedDevice
        case "createNewAttribute":
            guard let createAttributeViewController = segue.destination as? CreateAttributeViewController else {
                fatalError("Unexpected segue destination \(segue.destination)")
            }
            guard let groupController = self.groupController else {
                fatalError("No groupController while performing createNewAttribute view segue")
            }
            createAttributeViewController.groupController = groupController
        case "addNewDevice":
            guard let addDeviceVC = segue.destination as? GroupAddDeviceViewController else {
                fatalError("Unexpected segue destination \(segue.destination)")
            }
            guard let groupController = self.groupController else {
                fatalError("No groupController while performing createNewAttribute view segue")
            }
            addDeviceVC.groupController = groupController
        case "addNewUser":
            guard let addUserVC = segue.destination as? GroupAddUserViewController else {
                fatalError("Unexpected segue destination \(segue.destination)")
            }
            guard let groupController = self.groupController else {
                fatalError("No groupController while performing addNewUser view segue")
            }
            addUserVC.groupController = groupController
        default:
            return
        }
    }
    
    @IBAction func unwindToGroupDetail(_ segue : UIStoryboardSegue) {
        reloadRelevantList(section: segmentControl.selectedSegmentIndex)
    }
    
    func position(for bar: UIBarPositioning) -> UIBarPosition {
        return UIBarPosition.topAttached
    }
    
    func reloadRelevantList(section: Int) {
        switch(section) {
        case 0:
            self.loadDevices()
            break
        case 1:
            self.loadUsers()
            break
        case 2:
            self.loadAttributes()
            break
        default:
            fatalError("Could not reload this section \(section)")
        }
    }

}

