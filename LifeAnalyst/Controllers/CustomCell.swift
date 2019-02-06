//
//  CustomCellTableViewCell.swift
//  LifeAnalyst
//
//  Created by 山本竜也 on 2019/2/6.
//  Copyright © 2019 山本竜也. All rights reserved.
//

import UIKit

class CustomCell: UITableViewCell {

    @IBOutlet weak var timeLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
