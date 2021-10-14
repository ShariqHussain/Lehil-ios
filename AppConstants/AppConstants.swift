//
//  AppConstants.swift
//  Friends
//
//  Created by Shariq Hussain on 04/10/21.
//

import UIKit

class AppConstants: NSObject {
    
    static let shared = AppConstants()
    private override init() {
        
    }
    let baseUrl : String = "http://128.199.17.64:8080/LadakhInnerLinePermitPortal/rest/service/"
    let printPermitUrl : String = "https://www.lahdclehpermit.in/app-download-permit?groupId="
    let errorOccured : String = "Some Error Occurred. Please try again."
    let appName : String = "Leh Permit"
    let faqUrl : String = "https://www.lahdclehpermit.in/faq-app/"
    let greenColor : String = "#FF018786"
    let grayColor : String = "#D9D9D9"
    let blackColor : String = "#FF000000"
    
    // MARK: API End Point
    let GetAgentList : String = "getAgentList"
    let GetAgentPendingAmount : String = "getAgentPendingAmount"
    let SubmitContactForm : String = "submitContactForm"
    let AddTouristInformationForm : String = "addTouristInformationForm"
    let RegisterPermitRegistration : String = "registerPermitRegistration"
    
    
    let helplineInfo :[HelplineInfo] = [HelplineInfo(name: "Tourist Information Centre (TIC) Leh", phoneNumber: "01982-257788"),
                                        HelplineInfo(name: "Police", phoneNumber: "100"),
                                        HelplineInfo(name: "FIRE", phoneNumber: "101,132"),
                                        HelplineInfo(name: "Ambulance", phoneNumber: "102,108"),
                                        HelplineInfo(name: "Social Welfare Schemes", phoneNumber: "01982-252585"),
                                        HelplineInfo(name: "Rural Development Schemes", phoneNumber: "01982-252458"),
                                        HelplineInfo(name: "Tourism schemes", phoneNumber: "01982-252297"),
                                        HelplineInfo(name: "Agriculture schemes", phoneNumber: "01982-252028"),
                                        HelplineInfo(name: "Employment schemes", phoneNumber: "01982-252249"),
                                        HelplineInfo(name: "Health Schemes", phoneNumber: "01982-252012"),
                                       
    ]
}

