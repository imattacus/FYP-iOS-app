//
//  CreateAttributeViewController.swift
//  iot-control-app
//
//  Created by Matt Callaway on 08/07/2019.
//  Copyright © 2019 Matt Callaway. All rights reserved.
//

import UIKit

class CreateAttributeViewController: UITableViewController, UIPickerViewDelegate, UIPickerViewDataSource {
    
    
    static let datatypes:[String] = ["String", "Integer", "Boolean"]
    
    var groupController : GroupController!
    

    @IBOutlet weak var attributeNameTextField: UITextField!
    @IBOutlet weak var datatypePicker: UIPickerView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        datatypePicker.dataSource = self
        datatypePicker.delegate = self
    }
    
    // MARK: Spinner delegate and datasource
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return CreateAttributeViewController.datatypes.count
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return CreateAttributeViewController.datatypes[row]
    }
    
    @IBAction func doneClicked(_ sender: Any) {
        guard let name = attributeNameTextField.text, !name.isEmpty else {
            print("Invalid attribute name supplied to create attribute screen")
            let alert = UIAlertController(title: "Create Attribute", message: "You must provide a valid attribute name!", preferredStyle: .alert)
            alert.addAction(UIAlertAction(title:"Dismiss", style: .default))
            self.present(alert, animated: true, completion: nil)
            return
        }
        let datatype = CreateAttributeViewController.datatypes[datatypePicker.selectedRow(inComponent: 0)].lowercased()
        print("Got name \(name) datatype \(datatype)")
        groupController.createNewAttribute(name: name, datatype: datatype) {
            success in
            if (success) {
                print("Successfully created attribute")
                DispatchQueue.main.async {
                    self.performSegue(withIdentifier: "newAttributeComplete", sender: self)
                }
            } else {
                print("Error creating attribute")
                let alert = UIAlertController(title: "Create Attribute", message: "Sorry, there was an error creating this attribute!", preferredStyle: .alert)
                alert.addAction(UIAlertAction(title:"Dismiss", style: .default))
                self.present(alert, animated: true, completion: nil)
                return
            }
        }
            
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
