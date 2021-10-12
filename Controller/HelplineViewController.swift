//
//  HelplineViewController.swift
//  LehIL
//
//  Created by Shariq Hussain on 08/10/21.
//

import UIKit

class HelplineViewController: UIViewController,UITableViewDelegate, UITableViewDataSource {

    @IBOutlet weak var tblView: UITableView!
    override func viewDidLoad() {
        super.viewDidLoad()

        self.tblView.delegate = self
        self.tblView.dataSource = self
        self.tblView.backgroundColor = UIColor.clear
        // Do any additional setup after loading the view.
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

    
    private func callNumber(phoneNumber: String) {
        guard let url = URL(string: "telprompt://\(phoneNumber)"),
            UIApplication.shared.canOpenURL(url) else {
            return
        }
        UIApplication.shared.open(url, options: [:], completionHandler: nil)
    }
    
    @objc func onCLickCallButton(sender : UIButton)
    {
        let helpLineModelObj = AppConstants.shared.helplineInfo[sender.tag]
        let phoneNumberArr =  helpLineModelObj.phoneNumber.replacingOccurrences(of: "-", with: "").components(separatedBy: ",")

        let phoneNumberStr = phoneNumberArr[0] as String
        print(phoneNumberStr)
        self.callNumber(phoneNumber: phoneNumberStr)
    }
    
    
    // MARK: Table View Delegate and Data Source
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 81
    }
   
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "HelplineCell") as! HelplineCell
        let helpLineModelObj = AppConstants.shared.helplineInfo[indexPath.section]
        cell.nameLbl.text = "#\(indexPath.section + 1)" + " " + helpLineModelObj.name
        cell.phoneNumberLbl.text = helpLineModelObj.phoneNumber
        cell.callBtn.tag = indexPath.section
        cell.callBtn.addTarget(self, action: #selector(onCLickCallButton(sender:)), for: .touchUpInside)
        cell.selectionStyle = .none
        return cell
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: false)
        
    }
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 10; // space b/w cells
    }
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let header = UIView()
        header.isUserInteractionEnabled = false
        header.backgroundColor = UIColor.clear
        return header
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }
    func numberOfSections(in tableView: UITableView) -> Int {
       
        return AppConstants.shared.helplineInfo.count
    }
}
