//
//  DeviceViewController.swift
//  iot-control-app
//
//  Created by Matt Callaway on 28/02/2019.
//  Copyright © 2019 Matt Callaway. All rights reserved.
//

import UIKit

class DeviceViewController: UITableViewController, AttributeListContainer {
    
    let nc = NetworkController()
    let uc = UserController()
    
    var device : Device?
    var groupController : GroupController?
    
    @IBOutlet weak var deviceSwitch: UISwitch!
    @IBOutlet weak var attributesView: UIView!
    @IBOutlet weak var statusIndicator: UIActivityIndicatorView!
    @IBOutlet weak var config1switch: UISwitch!
    @IBOutlet weak var config1Indicator: UIActivityIndicatorView!
    @IBOutlet weak var config2Switch: UISwitch!
    @IBOutlet weak var config2Indicator: UIActivityIndicatorView!
    
    
    private var attributesListView : AttributeListTableViewController!
    private var selectedAttribute : Attribute?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        guard let device = self.device else {
            fatalError("No device to show")
        }
        self.navigationItem.title = "Device \(device.id)"
        deviceSwitch.isOn = (device.status == 1)
        config1switch.isOn = (device.config1 == 1)
        config2Switch.isOn = (device.config2 == 1)
        
        attributesListView = AttributeListTableViewController()
        attributesListView.setCallbackView(cb: self)
        attributesView.addSubview(attributesListView.view)
        
        loadAttributes()
        
    }
    
    func loadAttributes() {
        if let groupController = groupController {
            // Is not nil so this is for a group
            groupController.getDeviceAttributes(deviceID: device!.id) {
            	attributes in
                print("Got \(attributes.count) attributes for device")
                self.attributesListView.setContent(attributes: attributes)
                DispatchQueue.main.async {
                    self.tableView.reloadData()
                }
            }
        } else {
            // Group controller is nil so have to get attributes overall
            
        }
    }
    
    func attributeSelected(attribute: Attribute) {
        if let groupController = groupController {
            // This is a group view so should allow editing of attributes.. only if the user is admin though
            if (UserController.getUserID()! == groupController.getAdminID()) {
            	// User is not admin so alert them they can't change attributes
            	selectedAttribute = attribute
                performSegue(withIdentifier: "editAttribute", sender: self)
            }
        }
    }
    
    @IBAction func toggleSwitch(_ sender: Any, _ event: UIEvent) {
        let targetStatus = device!.status == 0 ? 1 : 0
        print("target status is \(targetStatus)")
        deviceSwitch.isHidden = true
        statusIndicator.startAnimating()
        nc.setDeviceStatus(userid: UserController.getUserID()!, deviceid: device!.id, status: targetStatus) { (success) in
            if (success) {
                print("Set device status completion")
                self.device!.status = targetStatus
                DispatchQueue.main.async {
                    self.deviceSwitch.isHidden = false
                    self.statusIndicator.stopAnimating()
                    self.deviceSwitch.isOn = (self.device!.status == 1)
                }
            } else {
                DispatchQueue.main.async {
                    self.deviceSwitch.isHidden = false
                    self.statusIndicator.stopAnimating()
                    self.deviceSwitch.isOn = self.device!.status == 1
                    self.failAlert()
                }
            }
        }
    }
    
    @IBAction func toggleConfig1(_ sender: Any) {
        let targetStatus = device!.config1 == 0 ? 1 : 0
        print("target status is \(targetStatus)")
        config1switch.isHidden = true
        config1Indicator.startAnimating()
        nc.setDeviceConfig1(userid: UserController.getUserID()!, deviceid: device!.id, status: targetStatus) { (success) in
            if (success) {
                print("Set device status completion")
                self.device!.config1 = targetStatus
                DispatchQueue.main.async {
                    self.config1switch.isHidden = false
                    self.config1Indicator.stopAnimating()
                    self.config1switch.isOn = (self.device!.config1 == 1)
                }
            } else {
                DispatchQueue.main.async {
                    self.config1switch.isHidden = false
                    self.config1Indicator.stopAnimating()
                    self.config1switch.isOn = (self.device!.config1 == 1)
                    self.failAlert()
                }
            }
        }
    }
    
    @IBAction func toggleConfig2(_ sender: Any) {
        let targetStatus = device!.config2 == 0 ? 1 : 0
        print("target status is \(targetStatus)")
        config2Switch.isHidden = true
        config2Indicator.startAnimating()
        nc.setDeviceConfig2(userid: UserController.getUserID()!, deviceid: device!.id, status: targetStatus) { (success) in
            if (success) {
                print("Set device status completion")
                self.device!.config2 = targetStatus
                DispatchQueue.main.async {
                    self.config2Switch.isHidden = false
                    self.config2Indicator.stopAnimating()
                    self.config2Switch.isOn = (self.device!.config2 == 1)
                }
            } else {
                DispatchQueue.main.async {
                    self.config2Switch.isHidden = false
                    self.config2Indicator.stopAnimating()
                    self.config2Switch.isOn = (self.device!.config2 == 1)
                    self.failAlert()
                }
            }
        }
    }
    
    func failAlert() {
        let alert = UIAlertController(title: "Error", message: "Sorry, could not do that - maybe you are not authorized!", preferredStyle: .alert)
        alert.addAction(UIAlertAction(title:"Dismiss", style: .default))
        self.present(alert, animated: true, completion: nil)
    }
    
    // MARK: Table View
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        switch(section) {
        case 0:
            return 3
        case 1:
            if (groupController != nil) {
                return 2
            } else {
                return 0
            }
        case 2:
            return 1
        default:
            fatalError("Error getting number of rows for section \(section)")
        }
    }
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        // Must make the cell for attributes be as long as the height of the contained tableview
        if (indexPath.section == 2 && indexPath.row == 0) {
            return attributesListView.tableView.contentSize.height
        } else {
            return 44
        }
    }
    
    override func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return (section == 1 && groupController == nil) ? CGFloat.leastNonzeroMagnitude : UITableView.automaticDimension
    }
    
    override func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        return (section == 1 && groupController == nil) ? CGFloat.leastNonzeroMagnitude : UITableView.automaticDimension
    }
    
    override func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        switch(section) {
        case 0:
            return "DEVICE CONTROLS"
        case 1:
            return (groupController == nil) ? nil : "GROUP CONTROLS"
        case 2:
            return "ATTRIBUTES"
        default:
            fatalError("Trying to get section header for section \(section)")
        }
    }
    
    override func tableView(_ tableView: UITableView, titleForFooterInSection section: Int) -> String? {
        switch(section) {
        case 0:
            return (device?.ownerid == UserController.getUserID()) ? "You are the owner of this device" : nil
        case 1:
            if (groupController == nil) {
                return nil
            } else if (groupController?.getAdminID() == UserController.getUserID()) {
                return "You are the admin for this group"
            } else {
                return nil
            }
        case 2:
            return nil
        default:
            fatalError("Trying to get section footer for section \(section)")
        }
    }

    // MARK: Navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        super.prepare(for: segue, sender: sender)
        switch(segue.identifier ?? "") {
        case "editAttribute":
            print("Device detail preparing for segue to edit attribute")
            guard let editAttributeVC = segue.destination as? EditAttributeViewController else {
                fatalError("Unexpected segue destination \(segue.destination)")
            }
            guard let groupController = groupController else {
                fatalError("device view about to segue to edit attribute with no group controller!")
            }
            // Give next VC the current device and the current group controller
            editAttributeVC.device = device
            editAttributeVC.groupController = groupController
            
            // If the user has selected an attribute, editVC should edit the relevant one, else its for a new attribute
            if let selectedAttribute = self.selectedAttribute {
                editAttributeVC.attribute = selectedAttribute
                self.selectedAttribute = nil
            }
        default:
            return
        }
    }

    
    @IBAction func unwindToDeviceDetail(_ segue : UIStoryboardSegue) {
    }

}
