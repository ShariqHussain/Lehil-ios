//
//  TouristInformationViewController.swift
//  LehIL
//
//  Created by Shariq Hussain on 10/10/21.
//

import UIKit

class TouristInformationViewController: UIViewController, UITableViewDataSource,UITableViewDelegate, UITextFieldDelegate, myTableDelegate, ViewControllerProtocol {
    
    @IBOutlet weak var pickerView: UIView!
    @IBOutlet weak var tblView: UITableView!
    @IBOutlet weak var datePicker: UIDatePicker!
    @IBOutlet weak var addTouristBottomConstraint: NSLayoutConstraint!
    
    @IBOutlet weak var nameTxtF: UITextField!
    @IBOutlet weak var ageTxtF: UITextField!
    @IBOutlet weak var addBtnOfAddTourist: UIButton!
    var addTouristBtnClicked : Bool = false
    var additionalTouristListArr : NSMutableArray = NSMutableArray()
    var headerInfoData : [String] = ["POINT OF ENTRY","DATE OF ARRIVAL (THIS IS THE DATE YOU ENTER LADAKH)","NAME","MOBILE NUMBER","VEHICLE NO/ FLIGHT NO","AGE","HOUSE NAME/ HOTEL NAME","DURATION OF STAY (IN DAYS)","TOURIST TYPE","STATE","",""]
    
    var pointOfEntryBtn : UIButton?
    var stateNationalityBtn : UIButton?
    var dateOfEntry : UIButton?
    var memberNameTxtField : UITextField?
    var mobileTxtField : UITextField?
    var memberAgeTxtField : UITextField?
    var vehicleNoTxtField : UITextField?
    var houseNameTxtField : UITextField?
    var durationOfStayTxtField : UITextField?
    var isApiRunning : Bool = false
    override func viewDidLoad() {
        super.viewDidLoad()

        self.pickerView.isHidden = true
        self.navigationController?.isNavigationBarHidden = true
        self.tblView.delegate = self
        self.tblView.dataSource = self
        self.tblView.tableFooterView = self.returnTableFooterView()
        
        self.nameTxtF.delegate = self
        self.ageTxtF.delegate = self
        
        if #available(iOS 13.0, *) {
            self.datePicker.minimumDate = NSDate.now
        } else {
            // Fallback on earlier versions
            self.datePicker.minimumDate = Date()
        }
        
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow(notification:)), name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillHide(notification:)), name: UIResponder.keyboardWillHideNotification, object: nil)
        // Do any additional setup after loading the view.
    }
    
    @objc private func keyboardWillShow(notification: NSNotification) {
        if let keyboardSize = (notification.userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue)?.cgRectValue {
            print(keyboardSize.height)
           self.tblView.contentInset = UIEdgeInsets(top: 0, left: 0, bottom: keyboardSize.height, right: 0)
            
            if(self.nameTxtF.isFirstResponder || self.ageTxtF.isFirstResponder)
            {
                if(self.addTouristBtnClicked)
                {
                    self.addTouristBottomConstraint.constant = keyboardSize.height - self.tabBarController!.tabBar.frame.size.height
                }
                else
                {
                    self.addTouristBtnClicked = true
                    self.addTouristBottomConstraint.constant = keyboardSize.height - self.tabBarController!.tabBar.frame.size.height
                }
                
                UIView.animate(withDuration: 1.0) {
                    self.view.layoutIfNeeded()
                }
            }
        }
    }

    @IBAction func datePickerValueChanged(_ sender: Any) {
       print("datePickerValueChanged")
        
    }
    @IBAction func onClickDoneOfDatePicker(_ sender: Any) {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "YYYY-MM-dd"
        
        self.dateOfEntry?.setTitle(dateFormatter.string(from: self.datePicker.date), for: .normal)
        self.pickerView.isHidden = true
    }
    @objc private func keyboardWillHide(notification: NSNotification) {
        self.tblView.contentInset = .zero
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        
        if(self.nameTxtF.isFirstResponder)
        {
            self.nameTxtF.resignFirstResponder()
            self.ageTxtF.resignFirstResponder()
            self.putDownAddTouristView()
        }
       
        return true
    }
    
    func myTableDelegate() {
           print("tapped")
           //modify your datasource here
        if(self.addTouristBottomConstraint.constant != -300 )
        {
            self.putDownAddTouristView()
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

    @IBAction func onClickBackBtn(_ sender: Any) {
        self.view.resignFirstResponder()
        self.navigationController?.popViewController(animated: true)
    }
    
    @IBAction func onClickSubmitAddTourist(_ sender: Any) {
        
        guard self.nameTxtF?.text != "" else {
            self.showAlerOnTheView(message: "Please enter name.", title: AppConstants.shared.appName, actionButtonName: "Ok")
            self.nameTxtF?.becomeFirstResponder()
            return
        }
        
        guard self.ageTxtF?.text != "" else {
            self.showAlerOnTheView(message: "Please enter age.", title: AppConstants.shared.appName, actionButtonName: "Ok")
            self.ageTxtF.becomeFirstResponder()
            return
        }
        
        self.nameTxtF.resignFirstResponder()
        self.ageTxtF.resignFirstResponder()
        if((sender as! UIButton).tag >= 0)
        {
            self.additionalTouristListArr[self.addBtnOfAddTourist.tag] = ["name" : self.nameTxtF.text! as String, "age" : self.ageTxtF.text! as String]
        }
        else
        {
            self.additionalTouristListArr.add(["name" : self.nameTxtF.text! as String, "age" : self.ageTxtF.text! as String])

        }
        self.putDownAddTouristView()
        self.tblView.reloadData()
        
    }
    // MARK: Table View Delegates
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        if(indexPath.section <= 10)
        {
            return 35
        }
        else
        {
            return 70
        }
        
    }
   
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        if(indexPath.section == 0)
        {
            let cell = tableView.dequeueReusableCell(withIdentifier: "TouristInfoBtnCell") as! TouristInfoBtnCell
            cell.cellBtn.addTarget(self, action: #selector(onClickPointOfEntry), for: .touchUpInside)
            self.pointOfEntryBtn = cell.cellBtn
            cell.selectionStyle = .none
            return cell
        }
        else if(indexPath.section == 1)
        {
            let cell = tableView.dequeueReusableCell(withIdentifier: "TouristInfoBtnCell") as! TouristInfoBtnCell
            cell.cellBtn.addTarget(self, action: #selector(onClickDateOfEntry), for: .touchUpInside)
            self.dateOfEntry = cell.cellBtn
            cell.selectionStyle = .none
            return cell
        }
        else if(indexPath.section == 8)
        {
            let cell = tableView.dequeueReusableCell(withIdentifier: "TouristSwitchCell") as! TouristSwitchCell
           
            cell.segmentControl.addTarget(self, action: #selector(onSegmentValueChange(sender:)), for: .valueChanged)
            cell.selectionStyle = .none
            return cell
        }
        else if(indexPath.section == 9)
        {
            let cell = tableView.dequeueReusableCell(withIdentifier: "TouristInfoBtnCell") as! TouristInfoBtnCell
            cell.cellBtn.addTarget(self, action: #selector(onClickStateNationality), for: .touchUpInside)
            self.stateNationalityBtn = cell.cellBtn
            cell.selectionStyle = .none
            return cell
        }
        else if(indexPath.section == 10)
        {
            // click to add tourist
            let cell = tableView.dequeueReusableCell(withIdentifier: "ClickToAddTouristCell") as! ClickToAddTouristCell
            cell.btnCell.backgroundColor = .clear
            cell.btnCell.tintColor = UIColor(hexString: AppConstants.shared.greenColor)
            cell.btnCell.setTitle("Click to add tourist", for: .normal)
            cell.btnCell.contentHorizontalAlignment = UIControl.ContentHorizontalAlignment.center
            cell.btnCell.addTarget(self, action: #selector(onClickAddTouristBtn(sender:)), for: .touchUpInside)
            cell.selectionStyle = .none
            return cell
        }
        else if (indexPath.section == 2 || indexPath.section == 3 || indexPath.section == 4 || indexPath.section == 5 || indexPath.section == 6 || indexPath.section == 7 )
        {
            let cell = tableView.dequeueReusableCell(withIdentifier: "TouristTxtFCell") as! TouristTxtFCell
            cell.delegate = self
            if(indexPath.section == 2)
            {
                cell.cellTxtF.placeholder = "Enter Name"
                self.memberNameTxtField = cell.cellTxtF
            }
            if(indexPath.section == 3)
            {
                cell.cellTxtF.placeholder = "Enter Mobile Number"
                cell.cellTxtF.keyboardType = .numberPad
                cell.cellTxtF.tag = 3
                self.mobileTxtField = cell.cellTxtF
            }
            if(indexPath.section == 4)
            {
                cell.cellTxtF.placeholder = "Enter Vehicle/ Flight No"
                self.vehicleNoTxtField = cell.cellTxtF
            }
            if(indexPath.section == 5)
            {
                cell.cellTxtF.placeholder = "Enter Age"
                cell.cellTxtF.keyboardType = .numberPad
                cell.cellTxtF.tag = 5
                self.memberAgeTxtField = cell.cellTxtF
            }
            if(indexPath.section == 6)
            {
                cell.cellTxtF.placeholder = "Enter House/ Hotel Name"
                self.houseNameTxtField = cell.cellTxtF
            }
            if(indexPath.section == 7)
            {
                cell.cellTxtF.placeholder = "Enter Duration Of Stay"
                cell.cellTxtF.keyboardType = .numberPad
                self.durationOfStayTxtField = cell.cellTxtF
            }
           
         //   cell.selectionStyle = .none
            return cell
        }
        else
        {
            let cell = tableView.dequeueReusableCell(withIdentifier: "AddTouristCell") as! AddTouristCell
            let dictObj = self.additionalTouristListArr[indexPath.row] as! NSDictionary
            cell.addTouristNameLbl.text = "  #\(indexPath.row+1)" + " " + "\(dictObj.value(forKey: "name") as! String)"
            cell.addTouristAgeLbl.text = "  Age: \(dictObj.value(forKey: "age") as! String)"
            cell.updateButton.tag = indexPath.row
            cell.updateButton.addTarget(self, action: #selector(onClickUpdateBtn(sender:)), for: .touchUpInside)
            cell.selectionStyle = .none
            return cell
        }
        
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: false)
//        self.view.endEditing(true)
//        self.putDownAddTouristView()
        
    }
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        if(section == 10 || section == 11)
        {
            return 1
        }
        else
        {
            return 20; // space b/w cells
        }
        
    }
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let header = UIView()
        if(section != 10)
        {
            header.frame = CGRect(x: 10, y: 0, width: self.tblView.frame.size.width-20, height: 20)
            header.backgroundColor = .clear
            let lbl : UILabel = UILabel()
            lbl.frame = CGRect(x: 10, y: 0, width: self.tblView.frame.size.width-20, height: 20)
            lbl.backgroundColor = .clear
            lbl.font = UIFont.systemFont(ofSize: 12)
            lbl.text = headerInfoData[section] as String
            header.addSubview(lbl)
            header.isUserInteractionEnabled = false
            
        }
        return header
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if(section == 11)
        {
           return self.additionalTouristListArr.count
        }
        else
        {
            return 1
        }
        
    }
    func numberOfSections(in tableView: UITableView) -> Int {
        return self.headerInfoData.count
    }
    
    func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
           return 2
       }

       func tableView(_ tableView: UITableView, viewForFooterInSection section: Int) -> UIView? {
           return UIView()
       }
    
    
    
    func returnTableFooterView() -> UIButton {
        let customView = UIButton(frame: CGRect(x: 0, y: 0, width: self.tblView.frame.width, height: 35))
        customView.backgroundColor = UIColor(hexString: AppConstants.shared.greenColor)
        customView.setTitle("SUBMIT", for: .normal)
        customView.addTarget(self, action: #selector(onClickMainSubmit), for: .touchUpInside)
        return customView
    }
    
    func putDownAddTouristView() -> Void {
        self.nameTxtF.text = ""
        self.ageTxtF.text = ""
        self.addTouristBottomConstraint.constant = -300
        UIView.animate(withDuration: 1.0) {
            self.view.layoutIfNeeded()
        }
    }
    
   
    
    @objc func onClickUpdateBtn(sender : UIButton)
    {
        self.nameTxtF.becomeFirstResponder()
        self.addBtnOfAddTourist.tag = sender.tag
        let dictObj = self.additionalTouristListArr[sender.tag] as! NSDictionary
        self.nameTxtF.text = dictObj.value(forKey: "name") as! String
        self.ageTxtF.text = dictObj.value(forKey: "age") as! String
    }
    
    
    @objc func onClickDateOfEntry()
    {
        self.putDownAddTouristView()
        self.view.endEditing(true)
        self.pickerView.isHidden = false
        
    }
    
    @objc func onClickStateNationality()
    {
        self.putDownAddTouristView()
        self.view.endEditing(true)
        var pickerTitleStr : String = ""
        var arrTheme : [String] = []
        if(self.headerInfoData[9] == "STATE")
        {
            pickerTitleStr = "Select State"
            arrTheme = ["Andaman and Nicobar Islands","Andhra Pradesh","Arunachal Pradesh","Assam","Bihar","Chandigarh","Chhattisgarh","Dadar and Nagar Haveli","Daman and Diu","Delhi",
                        "Goa","Gujarat","Haryana","Himachal Pradesh","Jharkhand","J&K","Karnataka","Kerala","Lakshadeep","Madya Pradesh","Maharashtra","Manipur",
                        "Meghalaya","Mizoram","Nagaland",
                        "Orissa","Pondicherry","Punjab","Rajasthan","Sikkim","Tamil Nadu","Telangana","Tripura","Uttarakhand","Uttaranchal","Uttar Pradesh","West Bengal"]
        }
        else
        {
            pickerTitleStr = "Select Country"
            arrTheme = ["Afghanistan","Australia","Benin","Bhutan","Croatia","Japan","India"]
        }
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
                self.stateNationalityBtn?.setTitle(selectedValue, for: .normal)
            }else{
                self.stateNationalityBtn?.setTitle("--Select--", for: .normal)
            }
        }, onCancel: {
            
        })
        picker.show(withAnimation: .FromBottom)
    }
    @objc func onClickPointOfEntry()
    {
        self.putDownAddTouristView()
        self.view.endEditing(true)
        let regularFont = UIFont.systemFont(ofSize: 16)
        let boldFont = UIFont.boldSystemFont(ofSize: 16)
        let theme = YBTextPickerAppearanceManager.init(
            pickerTitle         : "Select Entry Point",
            titleFont           : boldFont,
            titleTextColor      : .white,
            titleBackground     : nil,
            searchBarFont       : regularFont,
            searchBarPlaceholder: "Search Entry Point",
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
       
        let arrTheme = ["KBR Leh Airport","Khaltse","Upshi"]
        let picker = YBTextPicker.init(with: arrTheme, appearance: theme, onCompletion: { (selectedIndexes, selectedValues) in
            if let selectedValue = selectedValues.first{
                self.pointOfEntryBtn?.setTitle(selectedValue, for: .normal)
            }else{
                self.pointOfEntryBtn?.setTitle("--Select--", for: .normal)
            }
        }, onCancel: {
            
        })
        picker.show(withAnimation: .FromBottom)
    }
    
    @objc func onClickMainSubmit()
    {
        self.view.endEditing(true)
        // Clicked on main submit button
        guard self.pointOfEntryBtn!.titleLabel!.text! != "--SELECT--" else {
            self.showAlerOnTheView(message: "Please select point of entry.", title: AppConstants.shared.appName, actionButtonName: "Ok")
            return
        }

        guard self.dateOfEntry!.titleLabel!.text! != "--SELECT--" else {
            self.showAlerOnTheView(message: "Please select date of arrival.", title: AppConstants.shared.appName, actionButtonName: "Ok")
            return
        }
        guard self.memberNameTxtField?.text != "" else {
            self.showAlerOnTheView(message: "Please enter name.", title: AppConstants.shared.appName, actionButtonName: "Ok")
            return
        }
        guard self.mobileTxtField?.text != "" && (self.mobileTxtField?.text!.count)! >= 5 else {
            self.showAlerOnTheView(message: "Please enter valid mobile no.", title: AppConstants.shared.appName, actionButtonName: "Ok")
            return
        }
        guard self.vehicleNoTxtField?.text != "" else {
            self.showAlerOnTheView(message: "Please enter vehicle no.", title: AppConstants.shared.appName, actionButtonName: "Ok")
            return
        }
        guard self.memberAgeTxtField?.text != "" else {
            self.showAlerOnTheView(message: "Please enter age.", title: AppConstants.shared.appName, actionButtonName: "Ok")
            return
        }
        guard self.houseNameTxtField?.text != "" else {
            self.showAlerOnTheView(message: "Please enter house name.", title: AppConstants.shared.appName, actionButtonName: "Ok")
            return
        }
        guard self.durationOfStayTxtField?.text != "" else {
            self.showAlerOnTheView(message: "Please enter duration of stay.", title: AppConstants.shared.appName, actionButtonName: "Ok")
            return
        }
        guard self.stateNationalityBtn!.titleLabel!.text! != "--SELECT--" else {
            self.showAlerOnTheView(message: "Please select state or country.", title: AppConstants.shared.appName, actionButtonName: "Ok")
            return
        }

        // All validation is checked
        self.hitSubmitApi()
    }
    
    func hitSubmitApi() -> Void {
        
        if(self.isApiRunning)
        {
            return
        }
        AppDelegate.getAppDelegate().showActivityIndicatory(uiView: self.view)
        self.isApiRunning = true
        let dictObj = ["groupMember" : self.additionalTouristListArr]
        
        let paramStr : String = "pointOfEntry=\(self.pointOfEntryBtn!.titleLabel!.text!)&arrivalDateTime=\(self.dateOfEntry!.titleLabel!.text!)&name=\(self.memberNameTxtField!.text!)&mobile=\(self.mobileTxtField!.text!)&vehicleFlightNo=\(self.vehicleNoTxtField!.text!)&age=\(self.memberAgeTxtField!.text!)&hotelHouseAddress=\(self.houseNameTxtField!.text!)&durationOfStay=\(self.durationOfStayTxtField!.text!)&touristType=\(self.durationOfStayTxtField!.text!)&state=\(self.durationOfStayTxtField!.text!)&country=\(self.durationOfStayTxtField!.text!)&otherTouristInfo=\(dictObj)"
        let request : NSMutableURLRequest = RequestBuilder.clientURLRequestWithFormData(path: "\(AppConstants.shared.baseUrl)\(AppConstants.shared.AddTouristInformationForm)", params: paramStr)
        
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
                    print(data!)
                    if let statusVal = data!["errorCode"] as? Bool
                    {
                        if(!statusVal)
                        {
                            let  alert = UIAlertController(title: AppConstants.shared.appName, message: "Tourist information added successfully!", preferredStyle: .alert)
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
                else
                {
                    
                    self.showAlerOnTheView(message: AppConstants.shared.errorOccured, title: AppConstants.shared.appName, actionButtonName: "OK")
                }
    }
        
    }
    @objc func onClickAddTouristBtn(sender : UIButton)
    {
        print("Add Tourist Clicked")
        self.addBtnOfAddTourist.tag = -1
        self.nameTxtF.becomeFirstResponder()
        
    }
    @objc func onSegmentValueChange(sender : UISegmentedControl)
    {
        self.stateNationalityBtn?.setTitle("--Select--", for: .normal)
        switch sender.selectedSegmentIndex {
        case 0:
            self.headerInfoData[9] = "STATE"
        break
        case 1:
        
            self.headerInfoData[9] = "NATIONALITY"
        break
        default:
            break
        }
        
        self.tblView.reloadData()
        
    }
    
}
