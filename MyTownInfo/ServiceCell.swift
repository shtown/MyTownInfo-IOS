//
//  ServiceCell.swift
//  EastEndYouthServices
//
//  Created by John Daly on 8/21/16.
//  Copyright © 2016 TOS. All rights reserved.
//

import UIKit

class ServiceCell: UITableViewCell  {
    
    @IBOutlet var titleView: UILabel!
    @IBOutlet var descView: UILabel!

    @IBOutlet var launchBrowserIcon: UIImageView!
    @IBOutlet var launchDirectionsIcon: UIImageView!
    @IBOutlet var launchEmailIcon: UIImageView!
    @IBOutlet var launchTelIcon: UIImageView!
    
    
    func updateLabels() {
        let bodyFont = UIFont.preferredFont(forTextStyle: UIFont.TextStyle.body)
        let captionFont = UIFont.preferredFont(forTextStyle: UIFont.TextStyle.caption1)

        titleView.font = bodyFont
        descView.font = captionFont
        
    }
}
