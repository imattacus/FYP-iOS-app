//
//  DevicesListTableViewController.swift
//  iot-control-app
//
//  Created by Matt Callaway on 06/07/2019.
//  Copyright © 2019 Matt Callaway. All rights reserved.
//

import UIKit

class DevicesListTableViewController: UITableViewController {
    
    private var devices : [Device] = []
    private var parentViewCallback : DeviceListContainer!
        
    override func viewDidLoad() {
        super.viewDidLoad()
		tableView.register(UINib(nibName:"DeviceTableViewCell", bundle:nil), forCellReuseIdentifier: "deviceCell")
    }
    
    func setContent(devices : [Device]) {
        self.devices = devices
        DispatchQueue.main.async {
            self.tableView.reloadData()
        }
    }
    
    func setCallbackView(cb : DeviceListContainer) {
        self.parentViewCallback = cb
    }

    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return devices.count
    }

    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "deviceCell", for: indexPath) as! DeviceTableViewCell
        let device = devices[indexPath.row]

        cell.deviceNameLabel?.text = device.name
        cell.deviceStatusLabel?.text = device.status == 1 ? "On" : "Off"
        
        return cell
    }


    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        parentViewCallback.deviceSelected(device: devices[indexPath.row])
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
