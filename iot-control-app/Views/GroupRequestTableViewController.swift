//
//  GroupRequestTableViewController.swift
//  iot-control-app
//
//  Created by Matt Callaway on 11/07/2019.
//  Copyright © 2019 Matt Callaway. All rights reserved.
//

import UIKit

class GroupRequestTableViewController: UITableViewController, GroupRequestCellDelegate {
    
    private var requests : [GroupRequest] = []
    private let nc = NetworkController()
        
    override func viewDidLoad() {
        super.viewDidLoad()

        tableView.register(UINib(nibName:"GroupRequestTableViewCell", bundle: nil), forCellReuseIdentifier: "requestCell")
    }
    
    func setContent(requests : [GroupRequest]) {
        self.requests = requests
        DispatchQueue.main.async {
            self.tableView.reloadData()
        }
    }
    
    func acceptClicked(tag: IndexPath) {
        // Accept button clicked for request[tag]
        nc.respondToRequest(requestid: requests[tag.row].id, decision: "accept") {
            success in
            if (success) {
                // Remove the request from datasource
                self.requests.remove(at: tag.row)
                DispatchQueue.main.async {
                    self.tableView.reloadData()
                }
            } else {
                (self.tableView.cellForRow(at: tag) as! GroupRequestTableViewCell).showButtons()
                DispatchQueue.main.async {
                    let alert = UIAlertController(title: "Respond to Request", message: "Sorry, there was an error responding to request!", preferredStyle: .alert)
                    alert.addAction(UIAlertAction(title:"Dismiss", style: .default))
                    self.present(alert, animated: true, completion: nil)
                }
            }
        }
    }
    
    func declineClicked(tag: IndexPath) {
        nc.respondToRequest(requestid: requests[tag.row].id, decision: "decline") {
            success in
            if (success) {
                // Remove the request from datasource
                self.requests.remove(at: tag.row)
                DispatchQueue.main.async {
                    self.tableView.reloadData()
                }
            } else {
                (self.tableView.cellForRow(at: tag) as! GroupRequestTableViewCell).showButtons()
                DispatchQueue.main.async {
                    let alert = UIAlertController(title: "Respond to Request", message: "Sorry, there was an error responding to request!", preferredStyle: .alert)
                    alert.addAction(UIAlertAction(title:"Dismiss", style: .default))
                    self.present(alert, animated: true, completion: nil)
                }
            }
        }
    }

    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return requests.count
    }

    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "requestCell", for: indexPath) as! GroupRequestTableViewCell
        
        let request : GroupRequest = requests[indexPath.row]
        
		cell.indexPath = indexPath
        cell.delegate = self
        
        var text : String
        let fromuser = request.fromusername ?? "User \(String(request.fromuser))"
        let groupname = request.groupname ?? "Group \(String(request.groupid))"
        // Need to customise the text of the request depending on what type of request it is
        switch(request.purpose) {
        case "usergroupinvite":
            text = "\(fromuser) has invited you to join the group '\(groupname)'"
            break
        case "usergrouprequest":
            text = "\(fromuser) has requested to join your group '\(groupname)'"
            break
        default:
            fatalError("An unknown request type \(request.purpose)!")
        }
        
        cell.requestTextLabel.text = text

        return cell
    }
    
}
