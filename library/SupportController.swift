//
//  SupportController.swift
//  Library
//
//  Created by Andrey Polyskalov on 22.02.16.
//  Copyright © 2016 Kachkanar library. All rights reserved.
//

import UIKit
import SwiftyJSON

class SupportController: UIViewController {
    @IBOutlet weak var webview: UIWebView!

    let activityIndicator = UIActivityIndicatorView()

    override func viewDidLoad() {
        super.viewDidLoad()

        let url = URL(string: "https://chat.chatra.io/?hostId=dYM9sGGcftaFpskD7")
        let request = URLRequest(url: url!)
        webview.loadRequest(request)

        
        self.navigationItem.rightBarButtonItem = UIBarButtonItem(customView:activityIndicator)
        activityIndicator.startAnimating()
    }

    func webViewDidFinishLoad(_ webView_Pages: UIWebView) {
        activityIndicator.stopAnimating()
    }
}
