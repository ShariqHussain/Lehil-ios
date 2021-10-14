//
//  ExtensionHelper.swift
//  LehIL
//
//  Created by Shariq Hussain on 07/10/21.
//

import Foundation
import UIKit

extension UIViewController
{

    func showAlerOnTheView(message: String!, title: String!, actionButtonName: String!) -> Void {
        let  alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: actionButtonName, style: .default , handler: nil))
        self.present(alert, animated: true, completion: nil)
    }
    

}

