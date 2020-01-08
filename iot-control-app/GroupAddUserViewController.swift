//
//  GroupAddUserViewController.swift
//  iot-control-app
//
//  Created by Matt Callaway on 09/07/2019.
//  Copyright © 2019 Matt Callaway. All rights reserved.
//

import UIKit

class GroupAddUserViewController: UITableViewController {
    
    public var groupController : GroupController!

    @IBOutlet weak var usernameTextField: UITextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
    }

    @IBAction func doneClicked(_ sender: Any) {
        guard let username = usernameTextField.text, !username.isEmpty else {
            let alert = UIAlertController(title: "Add User", message: "Username can not be empty!", preferredStyle: .alert)
            alert.addAction(UIAlertAction(title:"Dismiss", style: .default))
            self.present(alert, animated: true, completion: nil)
            return
        }
        // Make request to add by username
        groupController.inviteUser(username: username) {
            success in
            if (success) {
                DispatchQueue.main.async {
                    let alert = UIAlertController(title: "Add User", message: "Request successfully sent!", preferredStyle: .alert)
                    alert.addAction(UIAlertAction(title:"OK", style: .default, handler: { _ in
                    	self.performSegue(withIdentifier: "addUserDone", sender: self)
                    }))
                    self.present(alert, animated: true, completion: nil)
                }
            } else {
                DispatchQueue.main.async {
                    let alert = UIAlertController(title: "Add User", message: "Could not add that user, maybe they do not exist", preferredStyle: .alert)
                    alert.addAction(UIAlertAction(title:"Dismiss", style: .default))
                    self.present(alert, animated: true, completion: nil)
                }
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
