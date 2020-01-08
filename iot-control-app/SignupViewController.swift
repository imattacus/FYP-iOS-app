//
//  SignupViewController.swift
//  iot-control-app
//
//  Created by Matt Callaway on 04/07/2019.
//  Copyright © 2019 Matt Callaway. All rights reserved.
//

import UIKit

class SignupViewController : UIViewController {
    @IBOutlet weak var usernameTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
    
    let uc = UserController()
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    @IBAction func signupClicked(_ sender: Any) {
        print("Sign up clicked!")
        guard let username = usernameTextField.text, !username.isEmpty else {
            print("No username supplied to sign up screen")
            let alert = UIAlertController(title: "Sign Up", message: "You must provide a username!", preferredStyle: .alert)
            alert.addAction(UIAlertAction(title:"Dismiss", style: .default))
            self.present(alert, animated: true, completion: nil)
            return
        }
        
        uc.registerNewUser(username: username) {
            user in
            if let user = user {
                DispatchQueue.main.async {
                    self.passwordTextField.text = "Successfully signed you up as user \(user.id)"
                }
            } else {
                DispatchQueue.main.async {
                    self.passwordTextField.text = "Failed"
                }
            }
        }
        
    }
}
