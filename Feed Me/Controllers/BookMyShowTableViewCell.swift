//
//  BookMyShowTableViewCell.swift
//  Feed Me
//
//  Created by Bhargavi Kulkarni on 06/02/16.
//  Copyright (c) 2016 Bhargavi Kulkarni. All rights reserved.
//


import UIKit

class BookMyShowTableViewCell: UITableViewCell {

  @IBOutlet weak var timeStamp: UILabel!
  @IBOutlet weak var showName: UILabel!
  @IBOutlet weak var showDetail: UILabel!
  @IBOutlet weak var date: UILabel!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
