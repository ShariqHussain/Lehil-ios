//
//  LinkWebViewController.swift
//  LehIL
//
//  Created by Shariq Hussain on 09/10/21.
//

import UIKit
import WebKit

class LinkWebViewController: UIViewController, WKUIDelegate, WKNavigationDelegate {

    @IBOutlet weak var navBarView: UIView!
    @IBOutlet weak var activityInd: UIActivityIndicatorView!
    @IBOutlet weak var webView: WKWebView!
    
    
     var urlStr : String?
    
     override func viewDidLoad() {
        super.viewDidLoad()

         self.activityInd.startAnimating()
         self.webView.uiDelegate = self
         self.webView.navigationDelegate = self
        self.navBarView.backgroundColor = UIColor(hexString: AppConstants.shared.greenColor)
        self.navigationController?.isNavigationBarHidden = true
        
        let url = URL(string: self.urlStr!)
        self.webView.load(URLRequest(url: url!))
        // Do any additional setup after loading the view.
    }
    @IBAction func onclickBackBtn(_ sender: Any) {
        self.webView.stopLoading()
        self.navigationController?.popViewController(animated: true)
    }
    
    
  
//    init?(urlStr : String, coder : NSCoder) {
//        self.urlStr = urlStr
//        super.init(coder: coder)
//    }
//
//    required init?(coder: NSCoder) {
//        fatalError("init(coder:) has not been implemented")
//    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

    //MARK:- WKNavigationDelegate

    func webView(_ webView: WKWebView, decidePolicyFor navigationAction: WKNavigationAction, decisionHandler: @escaping (WKNavigationActionPolicy) -> Void) {
            if navigationAction.navigationType == .linkActivated  {
                if let url = navigationAction.request.url,
                    let host = url.host, !host.hasPrefix("www.google.com"),
                    UIApplication.shared.canOpenURL(url) {
                    UIApplication.shared.open(url)
                    print(url)
                    print("Redirected to browser. No need to open it locally")
                    decisionHandler(.cancel)
                } else {
                    print("Open it locally")
                    decisionHandler(.allow)
                }
            } else {
                print("not a user click")
                decisionHandler(.allow)
            }
        }

    func webView(_ webView: WKWebView, didStartProvisionalNavigation navigation: WKNavigation!) {
       }

       func webView(_ webView: WKWebView, didFailProvisionalNavigation navigation: WKNavigation!, withError error: Error) {
           self.activityInd.stopAnimating()
           print("it is an error")
           let alert = UIAlertController(title: "Network Error", message: "You have no internet coonection", preferredStyle: .alert)

           let restartAction = UIAlertAction(title: "Reload page", style: .default, handler: { (UIAlertAction) in
               self.viewDidLoad()
           })

           alert.addAction(restartAction)
           present(alert, animated: true, completion: nil)
       }
       func webView(_ webView: WKWebView, didFinish navigation: WKNavigation!) {
           self.activityInd.stopAnimating()
           
       }
   
}
