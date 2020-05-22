//
//  DetailViewCell.swift
//  Prescription Reminder
//
//  Created by Jorge Collins Gómez on 01/05/20.
//  Copyright © 2020 CoRoSoftware. All rights reserved.
//

import UIKit

class DetailViewCell: UITableViewCell {

    @IBOutlet weak var keyLabel: UILabel!
    @IBOutlet weak var valueLabel: UILabel!
    
    var med : Med!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }


    
}
