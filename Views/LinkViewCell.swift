//
//  LinkViewCell.swift
//  LehIL
//
//  Created by Shariq Hussain on 08/10/21.
//

import UIKit

extension UIButton
{
    func addShadowonButton() -> Void {
        self.layer.shadowColor = UIColor.darkGray.cgColor
        self.layer.shadowOpacity = 1.0
        self.layer.shadowOffset = CGSize(width: 0, height: 0)
        self.layer.shadowRadius = 6
        self.layer.shouldRasterize = true
        self.layer.rasterizationScale = UIScreen.main.scale
    }
}

class LinkViewCell: UITableViewCell, UITextFieldDelegate {

    @IBOutlet weak var nameTxtF: UITextField!
    @IBOutlet weak var phoneNumberTxtF: UITextField!
    @IBOutlet weak var emailTxtF: UITextField!
    @IBOutlet weak var districtLehBtn: UIButton!
    @IBOutlet weak var kargilBtn: UIButton!
    @IBOutlet weak var lahdcBtn: UIButton!
    @IBOutlet weak var tourismBtn: UIButton!
    @IBOutlet weak var cultureBtn: UIButton!
    @IBOutlet weak var ICBtn1: UIButton!
    @IBOutlet weak var ICBtn2: UIButton!
    @IBOutlet weak var rndLbl1: UILabel!
    @IBOutlet weak var rndLbl2: UILabel!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        self.nameTxtF.delegate = self
        self.phoneNumberTxtF.delegate = self
        self.emailTxtF.delegate = self
        
        self.rndLbl1.layer.cornerRadius = self.rndLbl1.frame.height / 2
        self.rndLbl1.layer.masksToBounds = false
        self.rndLbl1.clipsToBounds = true
        
        self.rndLbl2.layer.cornerRadius = self.rndLbl2.frame.height / 2
        self.rndLbl2.layer.masksToBounds = false
        self.rndLbl2.clipsToBounds = true
        
        self.districtLehBtn.addShadowonButton()
        self.kargilBtn.addShadowonButton()
        self.lahdcBtn.addShadowonButton()
        self.tourismBtn.addShadowonButton()
        self.cultureBtn.addShadowonButton()
 
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        self.nameTxtF.resignFirstResponder()
        self.phoneNumberTxtF.resignFirstResponder()
        self.emailTxtF.resignFirstResponder()
        return true
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {

        if let touch = touches.first {

               if touch.view != self.nameTxtF || touch.view != self.phoneNumberTxtF || touch.view != self.emailTxtF{
                self.nameTxtF.resignFirstResponder()
                self.phoneNumberTxtF.resignFirstResponder()
                self.emailTxtF.resignFirstResponder()
               }
           }
       }

}
