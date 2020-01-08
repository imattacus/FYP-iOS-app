//
//  GroupAddDeviceViewController.swift
//  iot-control-app
//
//  Created by Matt Callaway on 09/07/2019.
//  Copyright © 2019 Matt Callaway. All rights reserved.
//

import UIKit

class GroupAddDeviceViewController: UITableViewController, UIPickerViewDelegate, UIPickerViewDataSource {

	let uc = UserController()
    public var groupController : GroupController!

    @IBOutlet weak var devicePicker: UIPickerView!
    
    var devices : [Device] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        devicePicker.delegate = self
        devicePicker.dataSource = self
        
        // Load users devices
        uc.loadUsersDevices {
            success in
            let userDevices = UserController.devices
            let groupDeviceIDs : [Int] = self.groupController.devices.map {
                device in
                return device.id
            }
            self.devices = userDevices.filter {
                device in
                return !groupDeviceIDs.contains(device.id)
            }
            DispatchQueue.main.async {
                self.devicePicker.reloadAllComponents()
            }
        }
    }

    @IBAction func doneClicked(_ sender: Any) {
        let device = devices[devicePicker.selectedRow(inComponent: 0)]
        groupController.addDevice(device: device) {
            success in
            if (success) {
                DispatchQueue.main.async {
                    self.performSegue(withIdentifier: "addDeviceDone", sender: self)
                }
            } else {
                print("Error adding device to group")
                DispatchQueue.main.async {
                    let alert = UIAlertController(title: "Add Device", message: "Sorry, there was an error adding the device to this group!", preferredStyle: .alert)
                    alert.addAction(UIAlertAction(title:"Dismiss", style: .default))
                    self.present(alert, animated: true, completion: nil)
                }
            }
        }
    }
    
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return devices.count
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return devices[row].name
    }
    
    // MARK: - Table view data source


    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
