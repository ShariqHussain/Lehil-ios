//
//  TouristInfoBtnCellTableViewCell.swift
//  LehIL
//
//  Created by Shariq Hussain on 10/10/21.
//

import UIKit

class TouristInfoBtnCell: UITableViewCell {

    @IBOutlet weak var cellBtn: UIButton!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        
        self.cellBtn.layer.cornerRadius = 2
        self.cellBtn.clipsToBounds = true
        self.cellBtn.layer.borderColor = UIColor.lightGray.cgColor
        self.cellBtn.layer.borderWidth = 1.0
        self.cellBtn.backgroundColor = UIColor.lightGray
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
