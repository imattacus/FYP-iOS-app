//
//  ClaimDeviceViewController.swift
//  iot-control-app
//
//  Created by Matt Callaway on 07/07/2019.
//  Copyright © 2019 Matt Callaway. All rights reserved.
//

import UIKit

class ClaimDeviceViewController: UITableViewController {

    @IBOutlet weak var deviceIDField: UITextField!
    @IBOutlet weak var doneButton: UIBarButtonItem!
    
    let uc = UserController()
    let nc = NetworkController()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    
    @IBAction func doneClicked(_ sender: Any) {
        guard let deviceID = deviceIDField.text, !deviceID.isEmpty, let deviceIDInt = Int(deviceID) else {
            print("Invalid device ID supplied to claim screen")
            let alert = UIAlertController(title: "Claim Device", message: "You must provide a valid numeric ID of the device you wish to claim!", preferredStyle: .alert)
            alert.addAction(UIAlertAction(title:"Dismiss", style: .default))
            self.present(alert, animated: true, completion: nil)
            return
        }
        // Tell network manager to send request to server claiming this device ID to current user
        nc.userClaimDevice(userid: UserController.getUserID()!, deviceid: deviceIDInt) {
            success in
            if (success) {
                print("Successfully claimed device")
                DispatchQueue.main.async {
                    self.performSegue(withIdentifier: "claimDeviceComplete", sender: self)
                }
            } else {
                print("Error claiming device")
                let alert = UIAlertController(title: "Claim Device", message: "Sorry, there was an error claiming your device!", preferredStyle: .alert)
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
