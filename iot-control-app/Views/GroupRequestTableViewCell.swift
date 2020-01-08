//
//  GroupRequestTableViewCell.swift
//  iot-control-app
//
//  Created by Matt Callaway on 11/07/2019.
//  Copyright © 2019 Matt Callaway. All rights reserved.
//

import UIKit

protocol GroupRequestCellDelegate {
    func acceptClicked(tag : IndexPath)
    func declineClicked(tag : IndexPath)
}

class GroupRequestTableViewCell: UITableViewCell {

    @IBOutlet weak var requestTextLabel: UILabel!
    @IBOutlet weak var acceptButton: UIButton!
    @IBOutlet weak var declineButton: UIButton!
    @IBOutlet weak var activityIndicator: UIActivityIndicatorView!
    
    public var indexPath : IndexPath!
    
    public var delegate : GroupRequestCellDelegate!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        activityIndicator.stopAnimating()
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    @IBAction func acceptClicked(_ sender: Any) {
        acceptButton.isHidden = true
        declineButton.isHidden = true
        activityIndicator.startAnimating()
        delegate.acceptClicked(tag: indexPath)
    }
    
    @IBAction func declineClicked(_ sender: Any) {
        acceptButton.isHidden = true
        declineButton.isHidden = true
        activityIndicator.startAnimating()
        delegate.declineClicked(tag: indexPath)
    }
    
    func showButtons() {
        acceptButton.isHidden = false
        declineButton.isHidden = false
        activityIndicator.stopAnimating()
        activityIndicator.isHidden = true
    }
    
}
