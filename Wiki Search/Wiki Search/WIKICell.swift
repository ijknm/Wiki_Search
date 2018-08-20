//
//  WIKICell.swift
//  Wiki Search
//
//  Created by praveen on 8/20/18.
//  Copyright © 2018 TubeRideShare. All rights reserved.
//

import UIKit

class WIKICell: UITableViewCell {

    @IBOutlet weak var ibImageLbl: UIImageView!
    @IBOutlet weak var ibDescriLbl: UILabel!
    @IBOutlet weak var ibTilteLbl: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
