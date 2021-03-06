//
//  FAQViewController.swift
//  LehIL
//
//  Created by Shariq Hussain on 07/10/21.
//

import UIKit
import WebKit
extension UIColor {
    convenience init(hexString: String) {
        let hex = hexString.trimmingCharacters(in: CharacterSet.alphanumerics.inverted)
        var int = UInt64()
        Scanner(string: hex).scanHexInt64(&int)
        let a, r, g, b: UInt64
        switch hex.count {
        case 3: // RGB (12-bit)
            (a, r, g, b) = (255, (int >> 8) * 17, (int >> 4 & 0xF) * 17, (int & 0xF) * 17)
        case 6: // RGB (24-bit)
            (a, r, g, b) = (255, int >> 16, int >> 8 & 0xFF, int & 0xFF)
        case 8: // ARGB (32-bit)
            (a, r, g, b) = (int >> 24, int >> 16 & 0xFF, int >> 8 & 0xFF, int & 0xFF)
        default:
            (a, r, g, b) = (255, 0, 0, 0)
        }
        self.init(red: CGFloat(r) / 255, green: CGFloat(g) / 255, blue: CGFloat(b) / 255, alpha: CGFloat(a) / 255)
    }
}
class FAQViewController: UIViewController,WKNavigationDelegate,WKUIDelegate {

    @IBOutlet weak var activityInd: UIActivityIndicatorView!
    @IBOutlet weak var webView: WKWebView!
    @IBOutlet weak var navBarView: UIView!
    override func viewDidLoad() {
        super.viewDidLoad()
        self.activityInd.startAnimating()
        self.webView.uiDelegate = self
        self.webView.navigationDelegate = self
        self.navBarView.backgroundColor = UIColor(hexString: AppConstants.shared.greenColor)
        self.navigationController?.isNavigationBarHidden = false
        let url = URL(string: AppConstants.shared.faqUrl)
        self.webView.load(URLRequest(url: url!))
        

        // Do any additional setup after loading the view.
    }
    
    //MARK:- WKNavigationDelegate

  
//    func webView(_ webView: WKWebView, createWebViewWith configuration: WKWebViewConfiguration, for navigationAction: WKNavigationAction, windowFeatures: WKWindowFeatures) -> WKWebView? {
//
//
//        webView.load(navigationAction.request)
//        return nil
//    }
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
   

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
