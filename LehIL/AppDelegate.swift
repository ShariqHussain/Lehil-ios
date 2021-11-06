//
//  AppDelegate.swift
//  LehIL
//
//  Created by Pankaj Yadav on 10/09/21.
//

import UIKit

@main
class AppDelegate: UIResponder, UIApplicationDelegate {

    var tempView : UIView? = UIView()
    var window: UIWindow?
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        Thread.sleep(forTimeInterval: 2.0)
        // Override point for customization after application launch.
        UITabBar.appearance().barTintColor = .white
        UITabBar.appearance().tintColor = UIColor(hexString: AppConstants.shared.greenColor)
        
        let tabBarController = self.window?.rootViewController as! UITabBarController
        tabBarController.selectedIndex = 1
        return true
    }

//    // MARK: UISceneSession Lifecycle
//
//    func application(_ application: UIApplication, configurationForConnecting connectingSceneSession: UISceneSession, options: UIScene.ConnectionOptions) -> UISceneConfiguration {
//        // Called when a new scene session is being created.
//        // Use this method to select a configuration to create the new scene with.
//        return UISceneConfiguration(name: "Default Configuration", sessionRole: connectingSceneSession.role)
//    }
//
//    func application(_ application: UIApplication, didDiscardSceneSessions sceneSessions: Set<UISceneSession>) {
//        // Called when the user discards a scene session.
//        // If any sessions were discarded while the application was not running, this will be called shortly after application:didFinishLaunchingWithOptions.
//        // Use this method to release any resources that were specific to the discarded scenes, as they will not return.
//    }
    
    func showActivityIndicatory(uiView: UIView) {
        let activityInd: UIActivityIndicatorView = UIActivityIndicatorView()
        tempView!.frame = CGRect(x: 0, y: 0, width: UIApplication.shared.windows[0].frame.size.width, height: UIApplication.shared.windows[0].frame.size.height)
        tempView!.backgroundColor = .clear
        activityInd.frame = CGRect(x: 0, y: 0, width: 40, height: 40)
        activityInd.center = tempView!.center
        activityInd.hidesWhenStopped = true
        if #available(iOS 13.0, *) {
            activityInd.style = .medium
        } else {
            // Fallback on earlier versions
            activityInd.style = .gray
        }
        activityInd.startAnimating()
        tempView!.addSubview(activityInd)
        uiView.addSubview(tempView!)
    }
    
    func removeActivityIndicator() -> Void {
        tempView!.removeFromSuperview()
    }

    
    class func getAppDelegate() -> AppDelegate
    {
        return UIApplication.shared.delegate! as! AppDelegate
    }

}

