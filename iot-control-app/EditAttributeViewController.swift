//
//  EditAttributeViewController.swift
//  iot-control-app
//
//  Created by Matt Callaway on 09/07/2019.
//  Copyright © 2019 Matt Callaway. All rights reserved.
//

import UIKit

class EditAttributeViewController: UITableViewController, UIPickerViewDelegate, UIPickerViewDataSource {
    
    public var groupController : GroupController!
    public var device : Device?
    public var user : User?
    public var attribute: Attribute?
    
    private var attributes : [Attribute] = []

    @IBOutlet weak var valueTextField: UITextField!
    @IBOutlet weak var attributePicker: UIPickerView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        attributePicker.dataSource = self
        attributePicker.delegate = self
		
        if let attribute = attribute {
            // An existing attribute has been supplied; so we are editing the value for one on this screen
            print("Existing attribute supplied")
            attributes.append(attribute)
            attributePicker.isUserInteractionEnabled = false
            attributePicker.alpha = CGFloat(0.6)
            attributePicker.reloadAllComponents()
            
            valueTextField.text = attribute.value
            print("Got \(attributes.count) attributes")
            
            self.navigationItem.title = "Edit \(attribute.prettyname)"
        } else {
            print("No attribute supplied so getting all attributes")
            // This screen is adding a new attribute/value
            groupController.getAttributes {
                self.attributes = self.groupController.attributes
                print("Got \(self.attributes.count) attributes")
                DispatchQueue.main.async {
                    self.attributePicker.reloadAllComponents()
                }
            }
        }
    }
    
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return attributes.count
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return "attribute: \(attributes[row].prettyname)"
    }
    
    @IBAction func cancelClicked(_ sender: Any) {
        if device != nil {
            performSegue(withIdentifier: "backToDevice", sender: self)
        } else if user != nil {
            performSegue(withIdentifier: "backToUser", sender: self)
        } else {
            fatalError("Edit attribute not got a user or a device to go back to!")
        }
    }
    
    @IBAction func doneClicked(_ sender: Any) {
        let attribute = attributes[attributePicker.selectedRow(inComponent: 0)]
        guard let value = valueTextField.text, !value.isEmpty else {
            let alert = UIAlertController(title: "Edit Attribute", message: "Value can not be empty!", preferredStyle: .alert)
            alert.addAction(UIAlertAction(title:"Dismiss", style: .default))
            self.present(alert, animated: true, completion: nil)
            return
        }
        if let device = device {
        	// Should add this attribute to a device
            groupController.editDeviceAttribute(attrid: attribute.id, deviceid: device.id, value: value) {
                success in
                if (success) {
                    DispatchQueue.main.async {
                        self.performSegue(withIdentifier: "backToDevice", sender: self)
                    }
                } else {
                    print("Error creating attribute")
                    let alert = UIAlertController(title: "Edit Attribute", message: "Sorry, there was an error editing this attribute!", preferredStyle: .alert)
                    alert.addAction(UIAlertAction(title:"Dismiss", style: .default))
                    self.present(alert, animated: true, completion: nil)
                    return
                }
            }
        } else if let user = user {
            // Should add this attribute to a user
            groupController.editUserAttribute(attrid: attribute.id, userid: user.id, value: value) {
                success in
                if (success) {
                    DispatchQueue.main.async {
                        self.performSegue(withIdentifier: "backToUser", sender: self)
                    }
                } else {
                    print("Error creating attribute")
                    let alert = UIAlertController(title: "Edit Attribute", message: "Sorry, there was an error editing this attribute!", preferredStyle: .alert)
                    alert.addAction(UIAlertAction(title:"Dismiss", style: .default))
                    self.present(alert, animated: true, completion: nil)
                    return
                }
            }
        } else {
            fatalError("Edit attribute has got no user or device to add this attribute to")
        }
    }
    
}
