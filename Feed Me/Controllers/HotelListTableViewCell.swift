//
//  HotelListTableViewCell.swift
//  Feed Me
//
//  Created by Bhargavi Kulkarni on 07/02/16.
//  Copyright (c) 2016 Bhargavi Kulkarni. All rights reserved.
//

import UIKit

class HotelListTableViewCell: UITableViewCell {

  @IBOutlet weak var name: UILabel!
  
  @IBOutlet weak var address: UILabel!
  
  @IBOutlet weak var rating: UILabel!
  
  @IBOutlet weak var thumbnail: UIImageView!
  
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
  
}
