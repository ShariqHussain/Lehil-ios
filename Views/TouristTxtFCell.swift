//
//  TouristTxtFCell.swift
//  LehIL
//
//  Created by Shariq Hussain on 10/10/21.
//

import UIKit
protocol myTableDelegate {
    func myTableDelegate()
}

class TouristTxtFCell: UITableViewCell, UITextFieldDelegate {

    @IBOutlet weak var cellTxtF: UITextField!
    var delegate: myTableDelegate?

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        cellTxtF.delegate = self
        
//        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(tapEdit(sender:)))
//        self.addGestureRecognizer(tapGesture)
    }

//     @objc func tapEdit(sender: UITapGestureRecognizer) {
//            delegate?.myTableDelegate()
//        }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        cellTxtF.resignFirstResponder()
        
        return true
    }
    
    func textFieldDidBeginEditing(_ textField: UITextField) {
        delegate?.myTableDelegate()
    }
    
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool{
        if(textField.tag == 5)
        {
            // age Text Field
            let maxLength = 2
               let currentString: NSString = (textField.text ?? "") as NSString
               let newString: NSString =
                   currentString.replacingCharacters(in: range, with: string) as NSString
               return newString.length <= maxLength
        }
        if(textField.tag == 3)
        {
            // mobile number Text Field
            let maxLength = 15
               let currentString: NSString = (textField.text ?? "") as NSString
               let newString: NSString =
                   currentString.replacingCharacters(in: range, with: string) as NSString
               return newString.length <= maxLength
        }
        return true
    }
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {

        if let touch = touches.first {

               if touch.view != self.cellTxtF {
                cellTxtF.resignFirstResponder()
               }
           }
       }


}
