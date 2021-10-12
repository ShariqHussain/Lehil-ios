//
//  LinksViewController.swift
//  LehIL
//
//  Created by Shariq Hussain on 08/10/21.
//

import UIKit


class LinksViewController: UIViewController,UITableViewDelegate, UITableViewDataSource, TextViewCellDelegate, ViewControllerProtocol {
    func updateCellHeight() {
        self.tblView.beginUpdates()
        self.tblView.endUpdates()
    }
    

    @IBOutlet weak var tblView: UITableView!
    
    var nameTxtField : UITextField? = nil
    var emailTxtField: UITextField?
    var phoneNumberTxtFiled : UITextField?
    @IBOutlet weak var navBarView: UIView!
    var txtView : UITextView?
    override func viewDidLoad() {
        super.viewDidLoad()

        self.tblView.delegate = self
        self.tblView.dataSource = self
        self.tblView.backgroundColor = UIColor.white
        self.view.backgroundColor =  UIColor.white
        
        self.navBarView.backgroundColor = UIColor(hexString: AppConstants.shared.greenColor)
        self.navigationController?.isNavigationBarHidden = true
     
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow(notification:)), name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillHide(notification:)), name: UIResponder.keyboardWillHideNotification, object: nil)
    }
    
 
    
    @objc private func keyboardWillShow(notification: NSNotification) {
        if let keyboardSize = (notification.userInfo?[UIResponder.keyboardFrameBeginUserInfoKey] as? NSValue)?.cgRectValue {
            print(keyboardSize.height)
            self.tblView.contentInset = UIEdgeInsets(top: 0, left: 0, bottom: keyboardSize.height, right: 0)
        }
    }

    @objc private func keyboardWillHide(notification: NSNotification) {
        self.tblView.contentInset = .zero
    }
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

  
    // MARK: Table View Delegate and Data Source
   
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        if(indexPath.row == 0)
        {
            let cell = tableView.dequeueReusableCell(withIdentifier: "LinkViewCell") as! LinkViewCell
            cell.selectionStyle = .none
            self.nameTxtField = cell.nameTxtF
            self.emailTxtField = cell.emailTxtF
            self.phoneNumberTxtFiled = cell.phoneNumberTxtF
            
            cell.districtLehBtn.addTarget(self, action: #selector(buttonLinkClicked(sender:)), for: .touchUpInside)
            cell.kargilBtn.addTarget(self, action: #selector(buttonLinkClicked(sender:)), for: .touchUpInside)
            cell.lahdcBtn.addTarget(self, action: #selector(buttonLinkClicked(sender:)), for: .touchUpInside)
            cell.tourismBtn.addTarget(self, action: #selector(buttonLinkClicked(sender:)), for: .touchUpInside)
            cell.cultureBtn.addTarget(self, action: #selector(buttonLinkClicked(sender:)), for: .touchUpInside)
            cell.ICBtn1.addTarget(self, action: #selector(iCBtn1Clicked(sender:)), for: .touchUpInside)
            cell.ICBtn2.addTarget(self, action: #selector(iCBtn2Clicked(sender:)), for: .touchUpInside)





            
            return cell
        }
        else if(indexPath.row == 2)
        {
            let cell = tableView.dequeueReusableCell(withIdentifier: "LinkSubmitButtonCell") as! LinkSubmitButtonCell
            cell.submitBtn.addTarget(self, action: #selector(buttonClicked(sender:)), for: .touchUpInside)
            cell.selectionStyle = .none
            return cell
        }
        else
        {
            let cell = tableView.dequeueReusableCell(withIdentifier: "LinkTextViewCell") as! LinkTextViewCell
            cell.delegate = self
            self.txtView = cell.txtView
            cell.selectionStyle = .none
            return cell
        }
    }
    
   
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: false)
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        if(indexPath.row == 0)
        {
            return 482
        }
        else if(indexPath.row == 2)
        {
            return 60
        }
        else
        {
           // let cell = self.tblView.dequeueReusableCell(withIdentifier: "LinkTextViewCell") as! LinkTextViewCell
            return UITableView.automaticDimension

        }
    }
    
  // MARK: Actions
    
    @objc func iCBtn1Clicked(sender : UIButton)
    {
        let url = URL(string: "https://www.lahdclehpermit.in/uploads/covid%20advisory-converted.pdf")
        if #available(iOS 10.0, *) {
            UIApplication.shared.open(url!, options: [:], completionHandler: nil)
        } else {
            UIApplication.shared.openURL(url!)
        }
    }
    
    @objc func iCBtn2Clicked(sender : UIButton)
    {
        let urlStr : String = "https://www.lahdclehpermit.in/"
        guard let linksWebViewController = storyboard?.instantiateViewController(identifier: "LinkWebViewController", creator: { coder in
            LinkWebViewController(urlStr: urlStr, coder: coder)
        }) else {
            fatalError("Unable to create an object")
        }
        self.navigationController?.pushViewController(linksWebViewController, animated: true)
    }
    
    @objc func buttonLinkClicked(sender: UIButton){
       //...
        
        self.txtView?.resignFirstResponder()
        self.nameTxtField?.resignFirstResponder()
        self.emailTxtField?.resignFirstResponder()
        self.phoneNumberTxtFiled?.resignFirstResponder()
        
        var urlStr : String = ""
        
        switch sender.tag {
        case 1:
            urlStr = "https://leh.nic.in/"
        case 2:
            urlStr = "https://kargil.nic.in/"
        case 3:
            urlStr = "https://leh.nic.in/lahdcleh/"
        case 4:
            urlStr = "https://leh.nic.in/tourism/"
        case 5:
            urlStr = "https://leh.nic.in/department/cultural-academy/"
        default:
            break
        }
        
        guard let linksWebViewController = storyboard?.instantiateViewController(identifier: "LinkWebViewController", creator: { coder in
            LinkWebViewController(urlStr: urlStr, coder: coder)
        }) else {
            fatalError("Unable to create an object")
        }
        
        self.navigationController?.pushViewController(linksWebViewController, animated: true)
    }
    
    @objc func buttonClicked(sender: UIButton){
       //... SubmitButtonClicked
        
        self.txtView?.resignFirstResponder()
        self.nameTxtField?.resignFirstResponder()
        self.emailTxtField?.resignFirstResponder()
        self.phoneNumberTxtFiled?.resignFirstResponder()
        
        if(self.isAllCheckValidated())
        {
            // Hit the Submit Api here
            self.hitSubmitApi()
        }
    }
    
    func hitSubmitApi() -> Void {
        let paramStr : String = "name=\(self.nameTxtField!.text!)&email=\(self.emailTxtField!.text!)&mobile=\(self.phoneNumberTxtFiled!.text!)&message=\(self.txtView!.text!)"
        let request : NSMutableURLRequest = RequestBuilder.clientURLRequestWithFormData(path: "\(AppConstants.shared.baseUrl)\(AppConstants.shared.SubmitContactForm)", params: paramStr)
        let serverConnector = ServerConnector()
        
        DispatchQueue.global().async {
            serverConnector.initializerHandlerDelegate = self as ViewControllerProtocol
            serverConnector.datatask(request1: request, method1: "POST")
        }
    }
    
    func initilizationHandler(status: Bool, data: NSDictionary?, error: NSString?) {
        DispatchQueue.main.async {
                if(data != nil)
                {
                    print(data!)
                    if let statusVal = data!["errorCode"] as? Bool
                    {
                        if(!statusVal)
                        {
                            self.showAlerOnTheView(message: "Your feedback is submitted.", title: AppConstants.shared.appName, actionButtonName: "Ok")
                            self.txtView?.resignFirstResponder()
                            self.nameTxtField?.resignFirstResponder()
                            self.emailTxtField?.resignFirstResponder()
                            self.phoneNumberTxtFiled?.resignFirstResponder()
                            self.nameTxtField?.text = ""
                            self.emailTxtField?.text = ""
                            self.phoneNumberTxtFiled?.text = ""
                            self.txtView?.text = ""
                        }
                        else
                        {
                            let errorMsg = data!["errorMessage"] as? NSString ?? AppConstants.shared.errorOccured as NSString
                            self.showAlerOnTheView(message: errorMsg as String, title: AppConstants.shared.appName, actionButtonName: "Ok")
                        }
                        
                    }
                    else
                    {
                       
                        self.showAlerOnTheView(message: AppConstants.shared.errorOccured, title: AppConstants.shared.appName, actionButtonName: "OK")
                        return
                    }
                    
                }
                else
                {
                    
                    self.showAlerOnTheView(message: AppConstants.shared.errorOccured, title: AppConstants.shared.appName, actionButtonName: "OK")
                }
    }
        
    }
    func isAllCheckValidated() -> Bool {
         guard (self.nameTxtField?.text) != nil && (self.nameTxtField?.text) != "" else
        {
            self.showAlerOnTheView(message: "Please enter name", title: AppConstants.shared.appName, actionButtonName: "Ok")
            return false
        }
        
        guard (self.emailTxtField?.text) != nil && (self.emailTxtField?.text) != "" && self.isValidEmailAddress(emailAddressString: self.emailTxtField?.text ?? "") else {
            self.showAlerOnTheView(message: "Please enter valid email", title: AppConstants.shared.appName, actionButtonName: "Ok")
            return false
        }
        guard (self.phoneNumberTxtFiled?.text) != nil && (self.phoneNumberTxtFiled?.text) != "" && self.phoneNumberTxtFiled?.text?.count == 10 else {
            self.showAlerOnTheView(message: "Please enter valid mobile number", title: AppConstants.shared.appName, actionButtonName: "Ok")
            return false
        }
        
        guard (self.txtView?.text) != nil && (self.txtView?.text) != "" else
        {
            self.showAlerOnTheView(message: "Please enter address", title: AppConstants.shared.appName, actionButtonName: "Ok")
            return false
        }
       
        return true
    }
    
    func isValidEmailAddress(emailAddressString: String) -> Bool {
      
      var returnValue = true
      let emailRegEx = "[A-Z0-9a-z.-_]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,3}"
      
      do {
          let regex = try NSRegularExpression(pattern: emailRegEx)
          let nsString = emailAddressString as NSString
          let results = regex.matches(in: emailAddressString, range: NSRange(location: 0, length: nsString.length))
          
          if results.count == 0
          {
              returnValue = false
          }
          
      } catch let error as NSError {
          print("invalid regex: \(error.localizedDescription)")
          returnValue = false
      }
      
      return  returnValue
  }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {

        if let touch = touches.first {

               if touch.view != self.txtView || touch.view != self.nameTxtField || touch.view != self.phoneNumberTxtFiled || touch.view != self.emailTxtField {
                self.txtView?.resignFirstResponder()
                self.nameTxtField?.resignFirstResponder()
                self.emailTxtField?.resignFirstResponder()
                self.phoneNumberTxtFiled?.resignFirstResponder()
               }
           }
       }
//    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
//        return 10; // space b/w cells
//    }
//    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
//        let header = UIView()
//        header.isUserInteractionEnabled = false
//        header.backgroundColor = UIColor.clear
//        return header
//    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 3
    }
//    func numberOfSections(in tableView: UITableView) -> Int {
//
//        return AppConstants.shared.helplineInfo.count
//    }
    
  
}
