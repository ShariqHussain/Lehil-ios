//
//  TouristInformationViewController.swift
//  LehIL
//
//  Created by Shariq Hussain on 10/10/21.
//

import UIKit

class TouristInformationViewController: UIViewController {
    
   
    override func viewDidLoad() {
        super.viewDidLoad()

        self.navigationController?.isNavigationBarHidden = true

        // Do any additional setup after loading the view.
    }
    

    
    

    @IBAction func onClickBackBtn(_ sender: Any) {
        self.view.resignFirstResponder()
        self.navigationController?.popViewController(animated: true)
    }
    
   
    
}
