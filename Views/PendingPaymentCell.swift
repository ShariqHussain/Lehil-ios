//
//  PendingPaymentCell.swift
//  LehIL
//
//  Created by Shariq Hussain on 08/10/21.
//

import UIKit

class PendingPaymentCell: UITableViewCell {

    @IBOutlet weak var groupIdLbl: UILabel!
    @IBOutlet weak var paidLbl: UILabel!
    @IBOutlet weak var amountLbl: UILabel!
    @IBOutlet weak var permitDateLbl: UILabel!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        self.paidLbl.layer.cornerRadius = 4
        self.paidLbl.clipsToBounds = true
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
