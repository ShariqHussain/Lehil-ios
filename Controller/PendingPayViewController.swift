//
//  PendingPayViewController.swift
//  LehIL
//
//  Created by Shariq Hussain on 07/10/21.
//

import UIKit
enum ApiTracer {
    case GetAgentList
    case GetPendingAmount
}
class PendingPayViewController: UIViewController,ViewControllerProtocol, UITableViewDelegate, UITableViewDataSource {
   
    let regularFont = UIFont.systemFont(ofSize: 16)
    let boldFont = UIFont.boldSystemFont(ofSize: 16)
    
    @IBOutlet weak var tblView: UITableView!
    @IBOutlet weak var totalAmountLbl: UILabel!
    @IBOutlet weak var selectedAgent: UILabel!
    @IBOutlet weak var activityIndicator: UIActivityIndicatorView!
    @IBOutlet weak var segmentControl: UISegmentedControl!
    var agentListArr : NSMutableArray = NSMutableArray()
    var arrayOfAgentListNames : NSMutableArray = NSMutableArray()
    var serverCallTracer : ApiTracer? = nil
    var pendingDomesticClientArr : NSMutableArray = NSMutableArray()
    var pendingForeignClientArr : NSMutableArray = NSMutableArray()
    var totalAmount : Int = 0
    var sourceArr: NSArray? = []
    var isApiRunning : Bool = false
    
    override func viewDidLoad() {
        self.title = "Pending Payment"
        self.tblView.delegate = self
        self.tblView.dataSource = self
        self.tblView.backgroundColor = UIColor.clear 
        self.callGetAgentList()
    }
    
    @IBAction func navigateback(_ sender: Any) {
        self.navigationController?.popViewController(animated: true)
    }
    
    @IBAction func onClickAgencyLogin(_ sender: Any) {
        
        let url = URL(string: "https://www.lahdclehpermit.in/agent/")
        if #available(iOS 10.0, *) {
            UIApplication.shared.open(url!, options: [:], completionHandler: nil)
        } else {
            UIApplication.shared.openURL(url!)
        }
    }
    @IBAction func onSengmentControlValueChanged(_ sender: Any) {
        
        switch self.segmentControl.selectedSegmentIndex {
        case 0:
            self.sourceArr = self.pendingDomesticClientArr
        case 1:
            self.sourceArr = self.pendingForeignClientArr
        default:
            break
        }
        
        self.tblView.reloadData()
    }
    func callGetAgentList() -> Void {
        if(self.isApiRunning)
        {
            return
        }
        AppDelegate.getAppDelegate().showActivityIndicatory(uiView: self.view)
        self.isApiRunning = true
        self.serverCallTracer = ApiTracer.GetAgentList
        let tempDict:[String: String] = [:]
        let request : NSMutableURLRequest = RequestBuilder.clientURLRequest(path: "\(AppConstants.shared.baseUrl)\(AppConstants.shared.GetAgentList)", params: tempDict as Dictionary)
        let serverConnector = ServerConnector()
        
        DispatchQueue.global().async {
            serverConnector.initializerHandlerDelegate = self as ViewControllerProtocol
            serverConnector.datatask(request1: request, method1: "POST")
        }
        
    }
    
    func callGetAgentPendingAmount() -> Void {

        if(self.isApiRunning)
        {
            return
        }
        AppDelegate.getAppDelegate().showActivityIndicatory(uiView: self.view)
        self.isApiRunning = true
        self.serverCallTracer = ApiTracer.GetPendingAmount
        let paramStr : String = "agentName=\(self.selectedAgent.text!)"
        let request : NSMutableURLRequest = RequestBuilder.clientURLRequestWithFormData(path: "\(AppConstants.shared.baseUrl)\(AppConstants.shared.GetAgentPendingAmount)", params: paramStr)
        let serverConnector = ServerConnector()
        
        DispatchQueue.global().async {
            serverConnector.initializerHandlerDelegate = self as ViewControllerProtocol
            serverConnector.datatask(request1: request, method1: "POST")
        }
        
    }
    func initilizationHandler(status: Bool, data: NSDictionary?, error: NSString?) {
        self.isApiRunning = false
        DispatchQueue.main.async {
            
            AppDelegate.getAppDelegate().removeActivityIndicator()
            self.totalAmount = 0
            if(self.serverCallTracer == ApiTracer.GetAgentList)
            {
                self.serverCallTracer = nil
                if(data != nil)
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
                    self.serverCallTracer = nil
                    self.showAlerOnTheView(message: AppConstants.shared.errorOccured, title: AppConstants.shared.appName, actionButtonName: "OK")
                }
            }
            else if (self.serverCallTracer == ApiTracer.GetPendingAmount)
            {
                self.pendingForeignClientArr.removeAllObjects()
                self.pendingDomesticClientArr.removeAllObjects()
                self.serverCallTracer = nil
                if(data != nil)
                {
                    if let statusVal = data!["errorCode"] as? Bool
                    {
                        
                        if(!statusVal)
                        {
                            
                           if let responseObj = data!["responseObject"] as? NSDictionary
                           {
                            
                            if let domesticClientArr = responseObj["pendingDomesticClient"] as? NSArray
                            {
                                for item in domesticClientArr as? [[String : AnyObject]] ?? []{
                                    self.pendingDomesticClientArr.add(item)
                                    if let amt = Int(item["total"] as! String)
                                    {
                                        self.totalAmount = self.totalAmount + amt
                                    }
                                }
                            }
                            
                            if let foreignClientArr = responseObj["pendingForeignClient"] as? NSArray
                            {
                                for item in foreignClientArr as? [[String : AnyObject]] ?? []{
                                    self.pendingForeignClientArr.add(item)
                                    if let amt = Int(item["total"] as! String)
                                    {
                                        self.totalAmount = self.totalAmount + amt
                                    }
                                }
                               
                            }
                            
                            self.totalAmountLbl.text = "Total Amount: ₹\(self.totalAmount)"
                            
                           }
                            
                            if(self.segmentControl.selectedSegmentIndex == 0)
                            {
                                self.sourceArr = self.pendingDomesticClientArr
                            }
                            else
                            {
                                self.sourceArr = self.pendingForeignClientArr
                            }
                            self.tblView.reloadData()
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
    }
    
   
    
    @IBAction func showAgentList(_ sender: Any) {
        
        if(self.agentListArr.count == 0)
        {
            return
        }
        self.arrayOfAgentListNames.removeAllObjects()
        
        for item  in self.agentListArr as! [[String: AnyObject]] {
            print(item)
            self.arrayOfAgentListNames.add(item["name"] as? String ?? "")
        }
        
        let theme = YBTextPickerAppearanceManager.init(
            pickerTitle         : "Select Agent",
            titleFont           : boldFont,
            titleTextColor      : .white,
            titleBackground     : nil,
            searchBarFont       : regularFont,
            searchBarPlaceholder: "Search Agency",
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
                self.selectedAgent.text = selectedValue
                // Here hit the api for fetching pending payment
                self.callGetAgentPendingAmount()
            }else{
                self.selectedAgent.text = "Select"
            }
        }, onCancel: {
            
        })
        picker.show(withAnimation: .FromBottom)
    }
    
    // MARK: Table View Delegates
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 100
    }
   
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let clientObj = self.sourceArr?.object(at: indexPath.section) as? [String: AnyObject]
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell") as! PendingPaymentCell
        cell.selectionStyle = .none
        cell.groupIdLbl.text = "#\(indexPath.section + 1)" + " " + String(clientObj?["groupId"] as? String ?? "")
        cell.paidLbl.text = String(clientObj?["status"] as? String ?? "")
        if let amnt = Int(clientObj?["total"] as! String)
        {
            cell.amountLbl.text = "Amount: ₹\(amnt)"
        }
        cell.permitDateLbl.text = "Permit Date: \(String(clientObj?["permitDate"] as? String ?? ""))"
        return cell
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: false)
        
    }
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 1; // space b/w cells
    }
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let header = UIView()
        header.isUserInteractionEnabled = false
        header.backgroundColor = UIColor.clear
        return header
    }
    
    func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        return 7
    }
    
    func tableView(_ tableView: UITableView, viewForFooterInSection section: Int) -> UIView? {
        let footer = UIView()
        footer.isUserInteractionEnabled = false
        footer.backgroundColor = UIColor.clear
        return footer
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }
    func numberOfSections(in tableView: UITableView) -> Int {
        if let arr = self.sourceArr
        {
            return arr.count
        }
        else{
            return 0
        }
    }
}
