//
//  RunningCell.swift
//  FitIOT
//
//  Created by abou on 06/11/2019.
//  Copyright © 2019 sanou abou. All rights reserved.
//

import UIKit

class RunningCell: UITableViewCell {

    @IBOutlet weak var idLabel: UILabel!
    @IBOutlet weak var timeLabel: UILabel!
    @IBOutlet weak var distanceLabel: UILabel!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
