//
//  SteamUserViewController.swift
//  SteamGamesNews
//
//  Created by Gemma Barrett on 13/09/2014.
//  Copyright (c) 2014 Gem Barrett. All rights reserved.
//

import Foundation
import UIKit

class SteamUserViewController: UIViewController, SteamAPIControllerProtocol {

    @IBOutlet weak var inputUsername: UITextField!
    @IBOutlet weak var submitUsername: UIButton!
    
    var vanityUsername : String = ""
    // api is a lazy variable as only created when first used
    lazy var api : SteamAPIController = SteamAPIController(delegate: self)
    lazy var APIkey : String = "STEAM-KEY-HERE"

    
    @IBAction func saveVanityID(sender:AnyObject) {
        println(inputUsername.text)
        if inputUsername.text.isEmpty {
            // show alert asking for vanity name
            println("No vanity name entered")
        }
        else {
            vanityUsername = inputUsername.text
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        var steamGamesNewsViewController: SteamGamesNewsViewController = segue.destinationViewController as SteamGamesNewsViewController
        api.getSteamID(APIkey, vanityid: vanityUsername)

    }

    func didReceiveAPIResults(steamIDReceived: NSDictionary) {
        
        //        if let response = newsResults["appnews"] as? NSDictionary {
        //            if let news = response["newsitems"] as? NSArray {
        //                dispatch_async(dispatch_get_main_queue(), {
        //                    self.news = News.newsWithJSON(news)
        //                    self.detailsTrackView!.reloadData()
        //                    UIApplication.sharedApplication().networkActivityIndicatorVisible = false
        //                })
        //            }
        //        }
    }

    
}