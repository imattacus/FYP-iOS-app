//
//  YourProfileViewController.swift
//  iot-control-app
//
//  Created by Matt Callaway on 11/07/2019.
//  Copyright © 2019 Matt Callaway. All rights reserved.
//

import UIKit

class YourProfileViewController: UITableViewController {
    
    private let uc = UserController()

    @IBOutlet weak var requestsView: UIView!
    
    private var requestsVC : GroupRequestTableViewController!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        requestsVC = GroupRequestTableViewController()
        requestsView.addSubview(requestsVC.view)
		
        loadRequests()
    }
    
    func loadRequests() {
        uc.loadUsersRequests {
            self.requestsVC.setContent(requests: UserController.requests)
            DispatchQueue.main.async {
                self.tableView.reloadData()
            }
        }
    }

    // MARK: - Table view data source

//    override func numberOfSections(in tableView: UITableView) -> Int {
//        // #warning Incomplete implementation, return the number of sections
//        return 1
//    }
//
//    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
//        return 0
//    }

    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        if (indexPath.section == 1 && indexPath.row == 0) {
            return requestsVC.tableView.contentSize.height
        } else {
            return 44
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
