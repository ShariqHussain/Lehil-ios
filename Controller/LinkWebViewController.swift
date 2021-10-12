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
    @IBOutlet weak var webView: WKWebView!
    
    private var urlStr : String
    override func viewDidLoad() {
        super.viewDidLoad()

        self.navBarView.backgroundColor = UIColor(hexString: AppConstants.shared.greenColor)
        self.navigationController?.isNavigationBarHidden = true
        
        let url = URL(string: self.urlStr)
        self.webView.load(URLRequest(url: url!))
        // Do any additional setup after loading the view.
    }
    @IBAction func onclickBackBtn(_ sender: Any) {
        self.webView.stopLoading()
        self.navigationController?.popViewController(animated: true)
    }
    init?(urlStr : String, coder : NSCoder) {
        self.urlStr = urlStr
        super.init(coder: coder)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

    //MARK:- WKNavigationDelegate

    private func webView(webView: WKWebView, didFailProvisionalNavigation navigation: WKNavigation!, withError error: NSError) {
        print(error.localizedDescription)
    }
    func webView(_ webView: WKWebView, didStartProvisionalNavigation navigation: WKNavigation!) {
        print("Start to load")
    }
    func webView(_ webView: WKWebView, didFinish navigation: WKNavigation!) {
        print("finish to load")
    }
}
