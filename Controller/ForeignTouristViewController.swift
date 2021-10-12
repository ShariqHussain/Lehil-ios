//
//  ForeignTouristViewController.swift
//  LehIL
//
//  Created by Rohit Garg on 25/09/21.
//

import UIKit


class ForeignTouristViewController: UIViewController {
  
    @IBAction func onClickBackButton(_ sender: Any) {
        self.view.resignFirstResponder()
        self.navigationController?.popViewController(animated: true)
    }
    override func viewDidLoad() {
        super.viewDidLoad()

        self.navigationController?.isNavigationBarHidden = true
        
        // Do any additional setup after loading the view.
    }
}
