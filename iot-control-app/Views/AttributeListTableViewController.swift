//
//  AttributeListTableViewController.swift
//  iot-control-app
//
//  Created by Matt Callaway on 06/07/2019.
//  Copyright © 2019 Matt Callaway. All rights reserved.
//

import UIKit

class AttributeListTableViewController: UITableViewController {
    
    private var attributes : [Attribute] = []
    private var parentViewCallback : AttributeListContainer!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView.register(UINib(nibName:"AttributeTableViewCell", bundle:nil), forCellReuseIdentifier: "attributeCell")
    }
    
    
    func setContent(attributes : [Attribute]) {
        self.attributes = attributes
        DispatchQueue.main.async {
            self.tableView.reloadData()
        }
    }
    
    func setCallbackView(cb : AttributeListContainer) {
        self.parentViewCallback = cb
    }

    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return attributes.count
    }

    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "attributeCell", for: indexPath) as! AttributeTableViewCell
        
        let attribute : Attribute = attributes[indexPath.row]
        
        cell.attributeLabel?.text = attribute.prettyname
        cell.datatypeLabel?.text = attribute.datatype
        if let value = attribute.value {
            cell.valueLabel?.isHidden = false
            cell.valueLabel?.text = value
        }

        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        parentViewCallback.attributeSelected(attribute: attributes[indexPath.row])
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
