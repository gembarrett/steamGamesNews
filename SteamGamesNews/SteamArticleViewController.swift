//
//  SteamArticleViewController.swift
//  SteamGamesNews
//
//  Created by Gemma Barrett on 02/09/2014.
//  Copyright (c) 2014 Gem Barrett. All rights reserved.
//

import Foundation
import UIKit

class SteamArticleViewController: UIViewController {

    @IBOutlet weak var newsItemView: UIWebView!
    
    var selectedNews : String = ""
    
    @IBAction func unwindToNewsList(sender: AnyObject) {
        self.dismissViewControllerAnimated(true, completion: nil)

    }
    override func viewDidLoad() {
        super.viewDidLoad()
//        UIApplication.sharedApplication().networkActivityIndicatorVisible = true
        let thisURL = selectedNews
        let requestURL = NSURL(string: selectedNews)
        let request = NSURLRequest(URL: requestURL!)
        newsItemView.loadRequest(request)
    }

}