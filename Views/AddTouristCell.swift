//
//  AddTouristCell.swift
//  LehIL
//
//  Created by Shariq Hussain on 10/10/21.
//

import UIKit

class AddTouristCell: UITableViewCell {

    @IBOutlet weak var mainView: UIView!
    @IBOutlet weak var addTouristNameLbl: UILabel!
    @IBOutlet weak var addTouristAgeLbl: UILabel!
    @IBOutlet weak var updateButton: UIButton!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        
        self.mainView.layer.cornerRadius = 2
        self.mainView.clipsToBounds = true
        self.mainView.layer.borderColor = UIColor.lightGray.cgColor
        self.mainView.layer.borderWidth = 1.0
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
