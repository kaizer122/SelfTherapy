//
//  channelCell.swift
//  SelfTherapy
//
//  Created by Ladjemi Kais on 5/3/19.
//  Copyright © 2019 esprit.tn. All rights reserved.
//

import UIKit

class channelCell: UITableViewCell {

    @IBOutlet weak var numberChat: UILabel!
    @IBOutlet weak var avatar: UIImageView!
    @IBOutlet weak var name: UILabel!
    @IBOutlet weak var author: UILabel!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
