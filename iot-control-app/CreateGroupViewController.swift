//
//  CreateGroupViewController.swift
//  iot-control-app
//
//  Created by Matt Callaway on 07/07/2019.
//  Copyright © 2019 Matt Callaway. All rights reserved.
//

import UIKit

class CreateGroupViewController: UITableViewController {
    
    let uc = UserController()
    let nc = NetworkController()

    @IBOutlet weak var groupNameTextField: UITextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()

    }

    @IBAction func doneClicked(_ sender: Any) {
        guard let groupName = groupNameTextField.text, !groupName.isEmpty else {
            print("Invalid group name supplied to create group screen")
            let alert = UIAlertController(title: "Create Group", message: "You must provide a valid group name!", preferredStyle: .alert)
            alert.addAction(UIAlertAction(title:"Dismiss", style: .default))
            self.present(alert, animated: true, completion: nil)
            return
        }
        // Tell network controller to create the new group
        nc.createNewGroup(userid: UserController.getUserID()!, groupname: groupName) {
            success in
            if (success) {
                print("Successfully created group")
                DispatchQueue.main.async {
                    self.performSegue(withIdentifier: "newGroupComplete", sender: self)
                }
            } else {
                print("Error creating group")
                let alert = UIAlertController(title: "Create Group", message: "Sorry, there was an error creating this group!", preferredStyle: .alert)
                alert.addAction(UIAlertAction(title:"Dismiss", style: .default))
                self.present(alert, animated: true, completion: nil)
                return
            }
        }
    }
    
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
