//
//  TwitterTableViewCell.swift
//  DestHack
//
//  Created by Bhargavi Kulkarni on 06/02/16.
//  Copyright (c) 2016 Bhargavi Kulkarni. All rights reserved.
//

import UIKit

class TwitterTableViewCell: UITableViewCell {

    @IBOutlet weak var imgCheck: UIImageView!
    @IBOutlet weak var lblData: UILabel!
    override func awakeFromNib() {
        super.awakeFromNib()
        imgCheck.layer.cornerRadius = 15.0
        
        // Initialization code
    }

    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
