//
//  SetsTableViewCell.swift
//  Ostmodern
//
//  Created by Administrator on 30/03/2016.
//  Copyright © 2016 mahesh lad. All rights reserved.
//

import UIKit

class SetsTableViewCell: UITableViewCell {

    
    
    @IBOutlet weak var setsImage: UIImageView!
 
    @IBOutlet weak var title: UILabel!
    
    @IBOutlet weak var episodeCountLabel: UILabel!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
