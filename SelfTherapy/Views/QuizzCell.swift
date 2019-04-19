//
//  QuizzCell.swift
//  SelfTherapy
//
//  Created by Ladjemi Kais on 4/19/19.
//  Copyright © 2019 esprit.tn. All rights reserved.
//

import UIKit

class QuizzCell: UITableViewCell {
    @IBOutlet weak var img : UIImageView!
    @IBOutlet weak var txt : UILabel!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
