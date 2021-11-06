//
//  AdvisoryViewController.swift
//  LehIL
//
//  Created by Shariq Hussain on 27/10/21.
//

import UIKit

class AdvisoryViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    
    @IBAction func onClickLink(_ sender: Any) {
        let url = URL(string: "https://www.lahdclehpermit.in/uploads/covid%20advisory-converted.pdf")
        if #available(iOS 10.0, *) {
            UIApplication.shared.open(url!, options: [:], completionHandler: nil)
        } else {
            UIApplication.shared.openURL(url!)
        }
    }
  
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {

        if let touch = touches.first {

            
            self.view.removeFromSuperview()
       }
    }
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
