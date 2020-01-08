//
//  UserDetailViewController.swift
//  iot-control-app
//
//  Created by Matt Callaway on 07/07/2019.
//  Copyright © 2019 Matt Callaway. All rights reserved.
//

import UIKit

class UserDetailViewController: UITableViewController, AttributeListContainer {
    

    @IBOutlet weak var attributeView: UIView!
    
    var user : User!
    var groupController: GroupController!
    
    @IBOutlet weak var attributesContainerCell: UITableViewCell!
    var attributesListView : AttributeListTableViewController!
    var selectedAttribute : Attribute?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        guard let user = self.user else {
            fatalError("No user passed to user detail view controller")
        }
        guard let groupController = self.groupController else {
            fatalError("No group controller passed to user detail view controller")
        }
        
        attributesListView = AttributeListTableViewController()
        attributesListView.setCallbackView(cb: self)
        attributeView.addSubview(attributesListView.view)
        
        groupController.getUserAttributes(userID: user.id) {
            attributes in
            print("Got \(attributes.count) attributes for user")
            self.attributesListView.setContent(attributes: attributes)
            DispatchQueue.main.async {
                self.tableView.reloadData()
            }
        }
        
        
        self.navigationItem.title = "User \(user.id): \(user.name)"

    }
    
    func attributeSelected(attribute: Attribute) {
        if (UserController.getUserID()! == groupController.getAdminID()) {
            // User is not admin so alert them they can't change attributes
            selectedAttribute = attribute
            performSegue(withIdentifier: "editAttribute", sender: self)
        }
    }

    // MARK: - Table view data source
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        if (indexPath.section == 1 && indexPath.row == 0) {
            return attributesListView.tableView.contentSize.height
        } else {
            return 44
        }
    }

//    override func numberOfSections(in tableView: UITableView) -> Int {
//        // #warning Incomplete implementation, return the number of sections
//        return 2
//    }
//
//    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
//        switch(section) {
//        case 0:
//            return 2
//        case 1:
//            return attributes.count
//        default:
//            return 0
//        }
//    }
    
//    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
//
//        switch(indexPath.section) {
//        case 0:
//
//        case 1:
//
//        default:
//            // error
//            fatalError()
//        }
//        let cell = tableView.dequeueReusableCell(withIdentifier: "attributeCell", for: indexPath) as! AttributeTableViewCell
//
//        let attribute : Attribute = attributes[indexPath.row]
//
//        cell.attributeLabel?.text = attribute.prettyname
//        cell.datatypeLabel?.text = attribute.datatype
//
//        return cell
//    }
    

    @IBAction func removeUserClicked(_ sender: Any) {
        print("Remove user clicked")
    }

    
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */
    
    @IBAction func unwindToUserDetailView(_ segue : UIStoryboardSegue) {
        
    }
    
    // MARK: Navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        super.prepare(for: segue, sender: sender)
        switch(segue.identifier ?? "") {
        case "editAttribute":
            print("User detail preparing for segue to edit attribute")
            guard let editAttributeVC = segue.destination as? EditAttributeViewController else {
                fatalError("Unexpected segue destination \(segue.destination)")
            }
            guard let groupController = groupController else {
                fatalError("user view about to segue to edit attribute with no group controller!")
            }
            // Give next VC the current device and the current group controller
            editAttributeVC.user = user
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

}
