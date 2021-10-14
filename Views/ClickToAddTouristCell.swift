//
//  ClickToAddTouristCell.swift
//  LehIL
//
//  Created by Shariq Hussain on 13/10/21.
//

import UIKit

class ClickToAddTouristCell: UITableViewCell {

    @IBOutlet weak var btnCell: UIButton!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        
        self.btnCell.layer.cornerRadius = 2
        self.btnCell.clipsToBounds = true
        self.btnCell.layer.borderColor = UIColor.lightGray.cgColor
        self.btnCell.layer.borderWidth = 1.0
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
