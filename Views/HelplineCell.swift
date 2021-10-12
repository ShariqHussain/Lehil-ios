//
//  HelplineCell.swift
//  LehIL
//
//  Created by Shariq Hussain on 08/10/21.
//

import UIKit

class HelplineCell: UITableViewCell {

    @IBOutlet weak var nameLbl: UILabel!
    @IBOutlet weak var phoneNumberLbl: UILabel!
    @IBOutlet weak var callBtn: UIButton!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        self.layer.cornerRadius = 2
        self.clipsToBounds = true
        self.layer.borderColor = UIColor.gray.cgColor
        self.layer.borderWidth = 1.0
        
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
