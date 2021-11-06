//
//  ForeignTouristViewController.swift
//  LehIL
//
//  Created by Rohit Garg on 25/09/21.
//

import UIKit

enum ApiTrack {
    case GetAgentList
    case SubmitData
}
class ForeignTouristViewController: UIViewController, UITableViewDataSource,UITableViewDelegate, UITextFieldDelegate,TextViewCellDelegate, ViewControllerProtocol {
    
    func updateCellHeight() {
        self.tblView.beginUpdates()
        self.tblView.endUpdates()
    }
    @IBOutlet weak var pickerView: UIView!
    @IBOutlet weak var tblView: UITableView!
    @IBOutlet weak var datePicker: UIDatePicker!
    
    var headerInfoData : [String] = ["NAME","MOBILE NUMBER","EMAIL ADDRESS", "GENDER","NATIONALITY","PASSPORT TYPE","PASSPORT NUMBER","VISA TYPE","VISA NUMBER","PERMANENT ADDRESS","CHOOSE YOUR AGENT","DATE OF ARRIVAL"]
    var nameTxtF : UITextField?
    var mobileNumberTxtF : UITextField?
    var emailTxtF : UITextField?
    var nationalityBtn : UIButton?
    var passportTypeBtn : UIButton?
    var passportNumberTxtF : UITextField?
    var visaTypeBtn : UIButton?
    var visaNumberTxtF : UITextField?
    var permanentAddressTxtView : UITextView?
    var chooseAgentBtn : UIButton?
    var dateOfArrivalBtn : UIButton?
    var selectedGender : String = "MALE"
    var agentListArr : NSMutableArray = NSMutableArray()
    var arrayOfAgentListNames : NSMutableArray = NSMutableArray()
    var serverCallTracer : ApiTrack? = nil
    var selectedAgentListId : String = ""
    var isApiRunning : Bool = false
    
    override func viewDidLoad() {
        super.viewDidLoad()

        self.pickerView.isHidden = true
        self.navigationController?.isNavigationBarHidden = true
        self.tblView.delegate = self
        self.tblView.dataSource = self
        self.tblView.tableFooterView = self.returnTableFooterView()
        
        if #available(iOS 13.0, *) {
            self.datePicker.minimumDate = NSDate.now
        } else {
            // Fallback on earlier versions
            self.datePicker.minimumDate = Date()
        }
        
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow(notification:)), name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillHide(notification:)), name: UIResponder.keyboardWillHideNotification, object: nil)
        self.callGetAgentList()
        // Do any additional setup after loading the view.
    }
   
    
    @IBAction func onClickBackButton(_ sender: Any) {
        self.view.resignFirstResponder()
        self.navigationController?.popViewController(animated: true)
    }
    
    @IBAction func datePickerValueChanged(_ sender: Any) {
       print("datePickerValueChanged")
       
    }
    @IBAction func onClickDoneOfDatePicker(_ sender: Any) {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "YYYY-MM-dd"
        
        self.dateOfArrivalBtn?.setTitle(dateFormatter.string(from: self.datePicker.date), for: .normal)
        self.pickerView.isHidden = true
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
    
    // MARK: Table View Delegates
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        if(indexPath.section == 9)
        {
            return UITableView.automaticDimension
        }
        else
        {
            return 35
        }
            
    }
   
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        if(indexPath.section == 0 || indexPath.section == 1 || indexPath.section == 2 || indexPath.section == 6 || indexPath.section == 8 )
        {
            let cell = tableView.dequeueReusableCell(withIdentifier: "TouristTxtFCell") as! TouristTxtFCell
            if(indexPath.section == 0)
            {
                cell.cellTxtF.placeholder = "Enter Name"
                self.nameTxtF = cell.cellTxtF
            }
            if(indexPath.section == 1)
            {
                cell.cellTxtF.placeholder = "Enter Mobile Number"
                cell.cellTxtF.keyboardType = .numberPad
                cell.cellTxtF.tag = 3
                self.mobileNumberTxtF = cell.cellTxtF
            }
            if(indexPath.section == 2)
            {
                cell.cellTxtF.placeholder = "Enter Email Address"
                cell.cellTxtF.keyboardType = .emailAddress
                self.emailTxtF = cell.cellTxtF
            }
            if(indexPath.section == 6)
            {
                cell.cellTxtF.placeholder = "Enter Passport Number"
                cell.cellTxtF.autocapitalizationType = .allCharacters
                self.passportNumberTxtF = cell.cellTxtF
            }
            if(indexPath.section == 8)
            {
                cell.cellTxtF.placeholder = "Enter Visa Number"
                self.visaNumberTxtF = cell.cellTxtF
            }
            
            return cell
        }
        else if(indexPath.section == 9)
        {
            let cell = tableView.dequeueReusableCell(withIdentifier: "LinkTextViewCell") as! LinkTextViewCell
            cell.delegate = self
            self.permanentAddressTxtView = cell.txtView
            cell.selectionStyle = .none
            return cell
        }
        else if(indexPath.section == 3)
        {
            let cell = tableView.dequeueReusableCell(withIdentifier: "TouristSwitchCell") as! TouristSwitchCell
            cell.segmentControl.addTarget(self, action: #selector(onSegmentValueChange(sender:)), for: .valueChanged)
            cell.selectionStyle = .none
            return cell
        }
        else
        {
            let cell = tableView.dequeueReusableCell(withIdentifier: "TouristInfoBtnCell") as! TouristInfoBtnCell
            cell.selectionStyle = .none
            if(indexPath.section == 4)
            {
                // Nationality
                
                cell.cellBtn.addTarget(self, action: #selector(onClickNationality), for: .touchUpInside)
                self.nationalityBtn = cell.cellBtn
                
            }
            if(indexPath.section == 5)
            {
                // passport type
                cell.cellBtn.addTarget(self, action: #selector(onClickPassportType), for: .touchUpInside)
                self.passportTypeBtn = cell.cellBtn
                
            }
            if(indexPath.section == 7)
            {
                //visa type
                cell.cellBtn.addTarget(self, action: #selector(onClickVisaType), for: .touchUpInside)
                self.visaTypeBtn = cell.cellBtn
                
            }
            if(indexPath.section == 10)
            {
                // agent
                cell.cellBtn.addTarget(self, action: #selector(onClickAgent), for: .touchUpInside)
                self.chooseAgentBtn = cell.cellBtn
            }
            if(indexPath.section == 11)
            {
                // date of arrival
                cell.cellBtn.addTarget(self, action: #selector(onClickDateOfArrival), for: .touchUpInside)
                self.dateOfArrivalBtn = cell.cellBtn
                
            }
                return cell
        }
        
       
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: false)
        self.view.endEditing(true)
    }
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
            return 20; // space b/w cells
    }
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let header = UIView()
            header.frame = CGRect(x: 10, y: 0, width: self.tblView.frame.size.width-20, height: 20)
            header.backgroundColor = .clear
            let lbl : UILabel = UILabel()
            lbl.frame = CGRect(x: 10, y: 0, width: self.tblView.frame.size.width-20, height: 20)
            lbl.backgroundColor = .clear
            lbl.font = UIFont.systemFont(ofSize: 12)
            lbl.text = headerInfoData[section] as String
            header.addSubview(lbl)
            header.isUserInteractionEnabled = false
            
        return header
    }
    
  

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
            return 1
    }
    func numberOfSections(in tableView: UITableView) -> Int {
        return self.headerInfoData.count
    }
    
    func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        if (section == 6)
        {
            return 30
        }
        else
        {
            return 2
        }
       }

       func tableView(_ tableView: UITableView, viewForFooterInSection section: Int) -> UIView? {
           
           if(section == 6)
           {
               let header = UIView()
                   header.frame = CGRect(x: 10, y: 0, width: self.tblView.frame.size.width-20, height: 30)
                   header.backgroundColor = .clear
                   let lbl : UILabel = UILabel()
                   lbl.frame = CGRect(x: 10, y: 0, width: self.tblView.frame.size.width-20, height: 30)
                   lbl.backgroundColor = .clear
                   lbl.font = UIFont.systemFont(ofSize: 12)
                   lbl.textColor = .red
                    lbl.numberOfLines = 2
                   lbl.text = "Permit cannot be issued to diplomatic passport holders. Kindly contact magistrate's office."
                   header.addSubview(lbl)
                   header.isUserInteractionEnabled = false
                   
               return header
           }
           else
           {
               return UIView()
           }
           
       }
    
    
    
    func returnTableFooterView() -> UIButton {
        let customView = UIButton(frame: CGRect(x: 0, y: 0, width: self.tblView.frame.width, height: 35))
        customView.backgroundColor = UIColor(hexString: AppConstants.shared.greenColor)
        customView.setTitle("SUBMIT", for: .normal)
        customView.addTarget(self, action: #selector(onClickMainSubmit), for: .touchUpInside)
        return customView
    }
    
    
   
    @objc func onClickNationality()
    {
        self.view.endEditing(true)
        var pickerTitleStr : String = ""
        var arrTheme : [String] = []
       
            pickerTitleStr = "Select Country"
            arrTheme = ["Afghanistan","Australia","Benin","Bhutan","Croatia","Japan","India"]
        let regularFont = UIFont.systemFont(ofSize: 16)
        let boldFont = UIFont.boldSystemFont(ofSize: 16)
        let theme = YBTextPickerAppearanceManager.init(
            pickerTitle         : pickerTitleStr,
            titleFont           : boldFont,
            titleTextColor      : .white,
            titleBackground     : nil,
            searchBarFont       : regularFont,
            searchBarPlaceholder: "Search",
            closeButtonTitle    : "Cancel",
            closeButtonColor    : .darkGray,
            closeButtonFont     : regularFont,
            doneButtonTitle     : "Done",
            doneButtonColor     : nil,
            doneButtonFont      : boldFont,
            checkMarkPosition   : .Right,
            itemCheckedImage    : nil,
            itemUncheckedImage  : nil,
            itemColor           : .black,
            itemFont            : regularFont
        )
       
        let picker = YBTextPicker.init(with: arrTheme, appearance: theme, onCompletion: { (selectedIndexes, selectedValues) in
            if let selectedValue = selectedValues.first{
                self.nationalityBtn?.setTitle(selectedValue, for: .normal)
            }else{
                self.nationalityBtn?.setTitle("--Select--", for: .normal)
            }
        }, onCancel: {
            
        })
        picker.show(withAnimation: .FromBottom)
    }
    
    @objc func onClickPassportType()
    {
        self.view.endEditing(true)
        let regularFont = UIFont.systemFont(ofSize: 16)
        let boldFont = UIFont.boldSystemFont(ofSize: 16)
        let theme = YBTextPickerAppearanceManager.init(
            pickerTitle         : "Select Passport Type",
            titleFont           : boldFont,
            titleTextColor      : .white,
            titleBackground     : nil,
            searchBarFont       : regularFont,
            searchBarPlaceholder: "Search",
            closeButtonTitle    : "Cancel",
            closeButtonColor    : .darkGray,
            closeButtonFont     : regularFont,
            doneButtonTitle     : "Done",
            doneButtonColor     : nil,
            doneButtonFont      : boldFont,
            checkMarkPosition   : .Right,
            itemCheckedImage    : nil,
            itemUncheckedImage  : nil,
            itemColor           : .black,
            itemFont            : regularFont
        )
       
        let arrTheme = ["Regular","Official"]
        let picker = YBTextPicker.init(with: arrTheme, appearance: theme, onCompletion: { (selectedIndexes, selectedValues) in
            if let selectedValue = selectedValues.first{
                self.passportTypeBtn?.setTitle(selectedValue, for: .normal)
            }else{
                self.passportTypeBtn?.setTitle("--Select--", for: .normal)
            }
        }, onCancel: {
            
        })
        picker.show(withAnimation: .FromBottom)
    }
    
    @objc func onClickVisaType()
    {
        self.view.endEditing(true)
        let regularFont = UIFont.systemFont(ofSize: 16)
        let boldFont = UIFont.boldSystemFont(ofSize: 16)
        let theme = YBTextPickerAppearanceManager.init(
            pickerTitle         : "Select Visa Type",
            titleFont           : boldFont,
            titleTextColor      : .white,
            titleBackground     : nil,
            searchBarFont       : regularFont,
            searchBarPlaceholder: "Search",
            closeButtonTitle    : "Cancel",
            closeButtonColor    : .darkGray,
            closeButtonFont     : regularFont,
            doneButtonTitle     : "Done",
            doneButtonColor     : nil,
            doneButtonFont      : boldFont,
            checkMarkPosition   : .Right,
            itemCheckedImage    : nil,
            itemUncheckedImage  : nil,
            itemColor           : .black,
            itemFont            : regularFont
        )
       
        let arrTheme = ["Entry Visa X","UN Official UD","Transit Visa TR","Tourist Visa T"]
        let picker = YBTextPicker.init(with: arrTheme, appearance: theme, onCompletion: { (selectedIndexes, selectedValues) in
            if let selectedValue = selectedValues.first{
                self.visaTypeBtn?.setTitle(selectedValue, for: .normal)
            }else{
                self.visaTypeBtn?.setTitle("--Select--", for: .normal)
            }
        }, onCancel: {
            
        })
        picker.show(withAnimation: .FromBottom)
    }
    
    @objc func onClickAgent()
    {
        self.view.endEditing(true)
        if(self.agentListArr.count == 0)
        {
            return
        }
        self.arrayOfAgentListNames.removeAllObjects()
        
        for item  in self.agentListArr as! [[String: AnyObject]] {
            print(item)
            self.arrayOfAgentListNames.add(item["name"] as? String ?? "")
        }
        let regularFont = UIFont.systemFont(ofSize: 16)
        let boldFont = UIFont.boldSystemFont(ofSize: 16)
        let theme = YBTextPickerAppearanceManager.init(
            pickerTitle         : "Select Agent Type",
            titleFont           : boldFont,
            titleTextColor      : .white,
            titleBackground     : nil,
            searchBarFont       : regularFont,
            searchBarPlaceholder: "Search",
            closeButtonTitle    : "Cancel",
            closeButtonColor    : .darkGray,
            closeButtonFont     : regularFont,
            doneButtonTitle     : "Done",
            doneButtonColor     : nil,
            doneButtonFont      : boldFont,
            checkMarkPosition   : .Right,
            itemCheckedImage    : nil,
            itemUncheckedImage  : nil,
            itemColor           : .black,
            itemFont            : regularFont
        )
       
        let arrTheme = self.arrayOfAgentListNames as! [String]
        let picker = YBTextPicker.init(with: arrTheme, appearance: theme, onCompletion: { (selectedIndexes, selectedValues) in
            if let selectedValue = selectedValues.first{
                self.chooseAgentBtn?.setTitle(selectedValue, for: .normal)
                if let selectedIndex = selectedIndexes.first
                {
                    
                  let dictObj =  self.agentListArr[selectedIndex] as! NSDictionary
                    let selectedId : String? = dictObj.value(forKey: "id") as? String ?? ""
                    self.selectedAgentListId = selectedId!
                    print(self.selectedAgentListId)
                }
            }else{
                self.chooseAgentBtn?.setTitle("--Select--", for: .normal)
            }
        }, onCancel: {
            
        })
        picker.show(withAnimation: .FromBottom)
    }
    
    @objc func onClickDateOfArrival()
    {
        self.view.endEditing(true)
        self.pickerView.isHidden = false
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
    
    
    @objc func onClickMainSubmit()
    {
        // Clicked on main submit button
        
        self.view.endEditing(true)
        guard self.nameTxtF?.text != "" else {
            self.showAlerOnTheView(message: "Please enter name.", title: AppConstants.shared.appName, actionButtonName: "Ok")
            return
        }

        guard self.mobileNumberTxtF?.text != "" && (self.mobileNumberTxtF?.text!.count)! >= 5 else {
            self.showAlerOnTheView(message: "Please enter valid mobile no.", title: AppConstants.shared.appName, actionButtonName: "Ok")
            return
        }

        guard self.emailTxtF?.text != "" && self.isValidEmailAddress(emailAddressString: self.emailTxtF?.text ?? "")else {
            self.showAlerOnTheView(message: "Please enter valid email.", title: AppConstants.shared.appName, actionButtonName: "Ok")
            return
        }
        guard self.nationalityBtn?.titleLabel!.text! != "--SELECT--" else {
            self.showAlerOnTheView(message: "Please select nationality.", title: AppConstants.shared.appName, actionButtonName: "Ok")
            return
        }
        guard self.passportTypeBtn?.titleLabel!.text! != "--SELECT--" else {
            self.showAlerOnTheView(message: "Please select passport type.", title: AppConstants.shared.appName, actionButtonName: "Ok")
            return
        }
        guard self.passportNumberTxtF?.text != "" else {
            self.showAlerOnTheView(message: "Please enter passport number.", title: AppConstants.shared.appName, actionButtonName: "Ok")
            return
        }
        guard self.visaTypeBtn?.titleLabel!.text! != "--SELECT--" else {
            self.showAlerOnTheView(message: "Please select visa type.", title: AppConstants.shared.appName, actionButtonName: "Ok")
            return
        }
        guard self.visaNumberTxtF?.text != "" else {
            self.showAlerOnTheView(message: "Please enter visa number.", title: AppConstants.shared.appName, actionButtonName: "Ok")
            return
        }
        guard self.permanentAddressTxtView?.text != "" else {
            self.showAlerOnTheView(message: "Please enter address.", title: AppConstants.shared.appName, actionButtonName: "Ok")
            return
        }
        guard self.chooseAgentBtn?.titleLabel!.text! != "--SELECT--" else {
            self.showAlerOnTheView(message: "Please select agent.", title: AppConstants.shared.appName, actionButtonName: "Ok")
            return
        }
        guard self.dateOfArrivalBtn?.titleLabel!.text! != "--SELECT--" else {
            self.showAlerOnTheView(message: "Please select date of arrival.", title: AppConstants.shared.appName, actionButtonName: "Ok")
            return
        }
    //     All validation is checked
        self.hitSubmitApi()
    }
    
    func callGetAgentList() -> Void {
    
        if(self.isApiRunning)
        {
            return
        }
        AppDelegate.getAppDelegate().showActivityIndicatory(uiView: self.view)
        self.isApiRunning = true
        self.serverCallTracer = ApiTrack.GetAgentList
        let tempDict:[String: String] = [:]
        let request : NSMutableURLRequest = RequestBuilder.clientURLRequest(path: "\(AppConstants.shared.baseUrl)\(AppConstants.shared.GetAgentList)", params: tempDict as Dictionary)
        let serverConnector = ServerConnector()
        
        DispatchQueue.global().async {
            serverConnector.initializerHandlerDelegate = self as ViewControllerProtocol
            serverConnector.datatask(request1: request, method1: "POST")
        }
        
    }
    func hitSubmitApi() -> Void {
        if(self.isApiRunning)
        {
            return
        }
        AppDelegate.getAppDelegate().showActivityIndicatory(uiView: self.view)

        self.isApiRunning = true
        self.serverCallTracer = ApiTrack.SubmitData
        let staticState : String = ""
        let permitType : String = ""
        let touristType : String = "Overseas"
        
        let date = Date()
        let calendar = Calendar.current
        let year = calendar.component(.year, from: date)
        
        
        let paramStr : String = "name=\(self.nameTxtF!.text!)&mobile=\(self.mobileNumberTxtF!.text!)&email=\(self.emailTxtF!.text!)&nationality=\(self.nationalityBtn!.titleLabel!.text!)&idType=\(self.passportTypeBtn!.titleLabel!.text!)&idNo=\(self.passportNumberTxtF!.text!)&visaType=\(self.visaTypeBtn!.titleLabel!.text!)&visaNumber=\(self.permanentAddressTxtView!.text!)&address=\(self.visaNumberTxtF!.text!)&gender=\(self.selectedGender)&arrivalDate=\(self.dateOfArrivalBtn!.titleLabel!.text!)&agentName=\(self.chooseAgentBtn!.titleLabel!.text!)&agentId=\(self.selectedAgentListId)&state=\(staticState)&permitType=\(permitType)&touristType=\(touristType)&year=\(year)"
        
        print(paramStr)
        let request : NSMutableURLRequest = RequestBuilder.clientURLRequestWithFormData(path: "\(AppConstants.shared.baseUrl)\(AppConstants.shared.RegisterPermitRegistration)", params: paramStr)
        
        print(paramStr)
        let serverConnector = ServerConnector()
        
        DispatchQueue.global().async {
            serverConnector.initializerHandlerDelegate = self as ViewControllerProtocol
            serverConnector.datatask(request1: request, method1: "POST")
        }
    }
    

    func initilizationHandler(status: Bool, data: NSDictionary?, error: NSString?) {
        DispatchQueue.main.async {
            AppDelegate.getAppDelegate().removeActivityIndicator()
            self.isApiRunning = false
                if(data != nil)
                {
                    
                    if(self.serverCallTracer == ApiTrack.GetAgentList)
                    {
                        self.agentListArr.removeAllObjects()
                        self.arrayOfAgentListNames.removeAllObjects()
                        if let statusVal = data!["errorCode"] as? Bool
                        {
                            if(!statusVal)
                            {
                                if let responseObj = data!["responseObject"] as? NSArray
                                {
                                 for item in responseObj{
                                     self.agentListArr.add(item as? NSDictionary ?? "")
                                 }
                                }
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
                        if let statusVal = data!["errorCode"] as? Bool
                        {
                            if(!statusVal)
                            {
                             
                                let  alert = UIAlertController(title: AppConstants.shared.appName, message: "Congratulations! Your registration is completed successfully.", preferredStyle: .alert)
                                alert.addAction(UIAlertAction(title: "Ok", style: .default, handler: { (action) in
                                    alert.dismiss(animated: true, completion: nil)
                                    self.navigationController?.popViewController(animated: true)
                                }))
                                self.present(alert, animated: true, completion: nil)
                                
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
                    
                }
                else
                {
                    self.serverCallTracer = nil
                    self.showAlerOnTheView(message: AppConstants.shared.errorOccured, title: AppConstants.shared.appName, actionButtonName: "OK")
                }
    }
        
    }
  
    @objc func onSegmentValueChange(sender : UISegmentedControl)
    {
        switch sender.selectedSegmentIndex {
        case 0:
            self.selectedGender = "MALE"
        break
        case 1:
            self.selectedGender = "FEMALE"
        break
        case 2:
            self.selectedGender = "OTHER"
        break
        default:
            break
        }
        
    }
    
}
