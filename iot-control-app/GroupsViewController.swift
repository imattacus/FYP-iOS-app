//
//  GroupsViewController.swift
//  iot-control-app
//
//  Created by Matt Callaway on 05/07/2019.
//  Copyright © 2019 Matt Callaway. All rights reserved.
//

import UIKit

class GroupsViewController : UITableViewController {
    
    let uc = UserController()
    var groups : [Group] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        loadGroups()
    }
    
    func loadGroups() {
        uc.loadUsersGroups {
            self.groups = UserController.groups
            print("Groups table sees \(self.groups.count) groups")
            DispatchQueue.main.async {
                self.tableView.reloadData()
            }
        }
    }
    
    // MARK: - Table view data source
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return groups.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "groupCell", for: indexPath)
        
        cell.textLabel?.text = "Group \(String(groups[indexPath.row].id)): \(groups[indexPath.row].name)"
        
        return cell
    }
    
    @IBAction func refreshClicked(_ sender: Any) {
        loadGroups()
    }
    
    @IBAction func addButtonClicked(_ sender: Any) {
        // User can either create a new group, or join an existing group -> So will show an action sheet alert to get their choice
        let newGroupAction = UIAlertAction(title: "Create New Group", style: .default) {
            (action) in
            // Segue to create new group
            DispatchQueue.main.async {
                self.performSegue(withIdentifier: "createNewGroup", sender: self)
            }
        }
        let joinGroupAction = UIAlertAction(title: "Join an Existing Group", style: .default) {
            (action) in
            // Show alert with text box to enter group name
            DispatchQueue.main.async {
                let alert = UIAlertController(title: "Join Group", message: "Please enter the name of the group you would like to join, a request will be sent to the group admin", preferredStyle: .alert)
                alert.addTextField(configurationHandler: {textField in
                    textField.placeholder = "Enter the exact name of the group"
                })
                alert.addAction(UIAlertAction(title:"Cancel", style: .cancel, handler: nil))
                alert.addAction(UIAlertAction(title:"Send Request", style: .default, handler: { alertAction in
                    print("Got text \(alert.textFields![0].text ?? "None")")
                }))
                self.present(alert, animated: true, completion: nil)
            }
        }
        let cancelAction = UIAlertAction(title:"Cancel", style: .cancel) {
            (action) in
            // Do nothing
        }
        
        let alert = UIAlertController(title: nil, message: nil, preferredStyle: .actionSheet)
        alert.addAction(newGroupAction)
        alert.addAction(joinGroupAction)
        alert.addAction(cancelAction)
        self.present(alert, animated: true, completion: nil)
        
    }
    
    
    //MARK: - Navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        super.prepare(for: segue, sender: sender)
        switch(segue.identifier ?? "") {
        case "showGroupDetail":
            guard let groupDetailViewController = segue.destination as? GroupDetailViewController else {
                fatalError("Unexpected segue destination: \(segue.destination)")
            }
            guard let selectedCell = sender as? UITableViewCell else {
                fatalError("Unexpected sender: /(sender)")
            }
            guard let indexPath = tableView.indexPath(for: selectedCell) else {
                fatalError("The selected cell is not being displayed by the table")
            }
            let selectedGroup = groups[indexPath.row]
            groupDetailViewController.group = selectedGroup
        default:
            return
        }
    }
    
    @IBAction func unwindToGroups(_ segue: UIStoryboardSegue) {
        
    }
    
    
}
