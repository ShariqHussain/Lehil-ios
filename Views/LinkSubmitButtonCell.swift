//
//  LinkSubmitButtonCell.swift
//  LehIL
//
//  Created by Shariq Hussain on 09/10/21.
//

import UIKit

class LinkSubmitButtonCell: UITableViewCell {

    @IBOutlet weak var submitBtn: UIButton!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        self.submitBtn.backgroundColor = UIColor(hexString: AppConstants.shared.greenColor)
        self.submitBtn.layer.cornerRadius = 4
        self.submitBtn.clipsToBounds = true
        self.submitBtn.layer.borderColor = UIColor.lightGray.cgColor
        self.submitBtn.layer.borderWidth = 1.0
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
