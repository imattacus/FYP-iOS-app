//
//  DevicesViewController.swift
//  iot-control-app
//
//  Created by Matt Callaway on 24/02/2019.
//  Copyright © 2019 Matt Callaway. All rights reserved.
//

import UIKit

class DevicesViewController: UITableViewController {

    let uc = UserController()
    var devices : [Device] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.refreshButton(self)
    }
    
    @IBAction func refreshButton(_ sender: Any) {
        // Refresh the devices
        uc.loadUsersDevices {
            success in
            if (success) {
                self.devices = UserController.devices
                DispatchQueue.main.async {
                    self.tableView.reloadData()
                }
            } else {
                let alert = UIAlertController(title: "Devices", message: "Could not load your devices!", preferredStyle: .alert)
                alert.addAction(UIAlertAction(title:"Dismiss", style: .default))
                self.present(alert, animated: true, completion: nil)
            }
        }
    }

    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return devices.count
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "deviceCell", for: indexPath)
        
        if (devices[indexPath.row].status == 1) {
            cell.detailTextLabel?.text = "On"
        } else {
            cell.detailTextLabel?.text = "Off"
        }
        
        cell.textLabel?.text = "Device \(devices[indexPath.row].id): \(devices[indexPath.row].name)"
        
        return cell
    }
    
//    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
//        
//    }
    
    
	//MARK: - Navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        super.prepare(for: segue, sender: sender)
        switch(segue.identifier ?? "") {
        case "showDeviceDetail":
            guard let deviceViewController = segue.destination as? DeviceViewController else {
                fatalError("Unexpected segue destination: \(segue.destination)")
            }
            guard let selectedCell = sender as? UITableViewCell else {
                fatalError("Unexpected sender: /(sender)")
            }
            guard let indexPath = tableView.indexPath(for: selectedCell) else {
                fatalError("The selected cell is not being displayed by the table")
            }
            let selectedDevice = devices[indexPath.row]
            deviceViewController.device = selectedDevice
        case "signOut":
            return
        default:
            return
        }
    }
    
    @IBAction func unwindWithSegue(_ segue: UIStoryboardSegue) {
    	// Reload device list in case something has changed
        self.refreshButton(self)
    }

}
