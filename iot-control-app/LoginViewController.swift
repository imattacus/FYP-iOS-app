//
//  LoginViewController.swift
//  iot-control-app
//
//  Created by Matt Callaway on 21/02/2019.
//  Copyright © 2019 Matt Callaway. All rights reserved.
//

import UIKit

class LoginViewController: UIViewController{
    @IBOutlet weak var usernameField: UITextField!
    @IBOutlet weak var passwordField: UITextField!
    
    let uc = UserController()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        
    }
    

    @IBAction func signinClicked(_ sender: Any) {
        guard let username: String = usernameField.text else {
            print("No username entered")
            return
        }
        uc.login(username: username, completion: {
            user in
            guard let id: Int = user?.id else {
                print("No user")
                return
            }
            DispatchQueue.main.async {
                self.passwordField.text = "Thanks for logging in user \(id)"
                self.performSegue(withIdentifier: "loginSuccess", sender: nil)
            }
        })
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
