//
//  LinkTextViewCell.swift
//  LehIL
//
//  Created by Shariq Hussain on 08/10/21.
//

import UIKit

protocol TextViewCellDelegate {
    
    func updateCellHeight()
}
class LinkTextViewCell: UITableViewCell, UITextViewDelegate {

    @IBOutlet weak var txtView: UITextView!
    @IBOutlet weak var placeholderLbl: UILabel!
    var delegate: TextViewCellDelegate?

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        self.txtView.delegate = self
        self.txtView.layer.cornerRadius = 4
       // self.txtView.clipsToBounds = true
        self.txtView.layer.borderColor = UIColor(hexString: "D1D1D6").cgColor 
        self.txtView.layer.borderWidth = 1.0
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    func textViewDidChange(_ textView: UITextView) {
        placeholderLbl.isHidden = !textView.text.isEmpty
        delegate?.updateCellHeight()
    }
    
    func textViewShouldEndEditing(_ textView: UITextView) -> Bool {
        self.txtView.resignFirstResponder()
        return true
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {

        if let touch = touches.first {

               if touch.view != self.txtView {
                self.txtView.resignFirstResponder()
               }
           }
       }


}
