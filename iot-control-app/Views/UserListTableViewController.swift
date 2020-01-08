//
//  UserListTableViewController.swift
//  iot-control-app
//
//  Created by Matt Callaway on 06/07/2019.
//  Copyright © 2019 Matt Callaway. All rights reserved.
//

import UIKit

class UserListTableViewController: UITableViewController {
    
    private var users : [User] = []
    private var parentViewCallback : UserListContainer!
        
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.register(UINib(nibName:"UserTableViewCell", bundle:nil), forCellReuseIdentifier: "userCell")
    }
    
    func setContent(users : [User]) {
        self.users = users
        print("Table sees \(self.users.count) users")
        DispatchQueue.main.async {
            self.tableView.reloadData()
        }
    }
    
    func setCallbackView(cb : UserListContainer) {
        self.parentViewCallback = cb
    }
    

    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return users.count
    }

    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "userCell", for: indexPath) as! UserTableViewCell

        cell.usernameLabel?.text = users[indexPath.row].name

        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        parentViewCallback.userSelected(user: users[indexPath.row])
    }



    
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
//    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
//        super.prepare(for: segue, sender: sender)
//        switch(segue.identifier ?? "") {
//        case "showUserDetail":
//            print("User list preparing for segue to user detail")
//            guard let userDetailViewController = segue.destination as? UserDetailViewController else {
//                fatalError("Unexpected segue destination \(segue.destination)")
//            }
//            userDetailViewController.user = self.selectedUser
//        default:
//            return
//        }
//    }
 
    
}
