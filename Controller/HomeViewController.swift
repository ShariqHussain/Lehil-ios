//
//  ViewController.swift
//  LehIL
//
//  Created by Pankaj Yadav on 10/09/21.
//

import UIKit

class HomeViewController: UIViewController, UITextFieldDelegate {

    @IBOutlet weak var navBarView: UIView!
    @IBOutlet weak var printView: UIView!
    @IBOutlet weak var groupIdTextField: UITextField!
    @IBOutlet weak var printPermitViewConstraint: NSLayoutConstraint!
    @IBOutlet weak var pagerView: FSPagerView! {
        didSet {
            self.pagerView.register(FSPagerViewCell.self, forCellWithReuseIdentifier: "cell")
            self.pagerView.dataSource = self
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        self.navBarView.backgroundColor = UIColor(hexString: AppConstants.shared.greenColor)
        self.navigationController?.setNavigationBarHidden(true, animated: false)
        self.groupIdTextField.delegate = self
        
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow(notification:)), name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillHide(notification:)), name: UIResponder.keyboardWillHideNotification, object: nil)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        self.printPermitViewConstraint.constant = -300
        self.view.layoutIfNeeded()
        super.viewWillAppear(true)
    }

    @IBAction func domesticTouristDidTap(_ sender: Any) {
    }
    
    @IBAction func ForeignTouristDidTap(_ sender: Any) {
        
        guard let foreignTouristViewController = self.storyboard?.instantiateViewController(identifier: "ForeignTouristViewController") as? ForeignTouristViewController else {
            fatalError("Failed to load ForeignTouristViewController from storyboard")
        }
        self.navigationController?.pushViewController(foreignTouristViewController, animated: true)
    }
    
    @IBAction func pendingPaymentDidTap(_ sender: Any) {
        guard let pendingPayVC = self.storyboard?.instantiateViewController(withIdentifier: "PendingPayVC") as? PendingPayViewController else {
            fatalError("Failed to load PendingPaymentViewController from storyboard.")
        }
        self.navigationController?.pushViewController(pendingPayVC, animated: true)
    }
    
    @IBAction func printPermitDidTap(_ sender: Any) {
        self.groupIdTextField.becomeFirstResponder()
    }
    
    @IBAction func touristInfoDidTap(_ sender: Any) {
        
        guard let touristInformationViewController = self.storyboard?.instantiateViewController(withIdentifier: "TouristInformationViewController") as? TouristInformationViewController else {
            fatalError("Failed to load PendingPaymentViewController from storyboard.")
        }
        self.navigationController?.pushViewController(touristInformationViewController, animated: true)
    }
    @IBAction func onCLickPrintOfPrintPermit(_ sender: Any) {
        
        guard self.groupIdTextField?.text != "" else {
            self.showAlerOnTheView(message: "Please enter Group Id.", title: AppConstants.shared.appName, actionButtonName: "Ok")
            return
        }
        
        self.printPermitViewConstraint.constant = -300
        UIView.animate(withDuration: 1.0) {
            self.view.layoutIfNeeded()
        }
        self.openPrintPermitUrl()
        
        // Hit he url with group Id
    }
    
    func openPrintPermitUrl() -> Void {
        guard let url = URL(string: AppConstants.shared.printPermitUrl + self.groupIdTextField.text!) else { return }
        print(url)
        UIApplication.shared.open(url)
    }
    @objc private func keyboardWillShow(notification: NSNotification) {
        if let keyboardSize = (notification.userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue)?.cgRectValue {
            
            self.printPermitViewConstraint.constant = keyboardSize.height - self.tabBarController!.tabBar.frame.size.height
            UIView.animate(withDuration: 1.0) {
                self.view.layoutIfNeeded()
            }
        }
    }

    @objc private func keyboardWillHide(notification: NSNotification) {
        self.printPermitViewConstraint.constant = -300
        UIView.animate(withDuration: 1.0) {
            self.view.layoutIfNeeded()
        }
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        
        guard self.groupIdTextField?.text != "" else {
            self.showAlerOnTheView(message: "Please enter Group Id.", title: AppConstants.shared.appName, actionButtonName: "Ok")
            return false
        }
        self.groupIdTextField.resignFirstResponder()
        self.openPrintPermitUrl()
        self.printPermitViewConstraint.constant = -300
        UIView.animate(withDuration: 1.0) {
            self.view.layoutIfNeeded()
        }
        return true
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {

        if let touch = touches.first {
               if touch.view != self.groupIdTextField {
                self.groupIdTextField.resignFirstResponder()
                self.printPermitViewConstraint.constant = -300
                UIView.animate(withDuration: 1.0) {
                    self.view.layoutIfNeeded()
                }
               }
           }
       }
    
}

//MARK: Banner Datasource
extension HomeViewController: FSPagerViewDataSource {
    
    public func numberOfItems(in pagerView: FSPagerView) -> Int {
        return 3
    }
        
    public func pagerView(_ pagerView: FSPagerView, cellForItemAt index: Int) -> FSPagerViewCell {
        let cell = pagerView.dequeueReusableCell(withReuseIdentifier: "cell", at: index)
        cell.imageView?.image = UIImage(named: "\(index)")
        cell.textLabel?.text = "Leh District Tourish Management System"
        return cell
    }

}

extension HomeViewController {
    
}
