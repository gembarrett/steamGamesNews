//
//  SteamUserViewController.swift
//  SteamGamesNews
//
//  Created by Gemma Barrett on 13/09/2014.
//  Copyright (c) 2014 Gem Barrett. All rights reserved.
//

import Foundation
import UIKit

class SteamUserViewController: UIViewController {

    @IBOutlet weak var inputUsername: UITextField!
    @IBOutlet weak var submitUsername: UIButton!
    
    @IBAction func vanityidExplanation(sender: AnyObject) {
        var myAlertView = UIAlertView()
        
        myAlertView.title = "What is my vanity ID?"
        myAlertView.message = "\r Your vanity ID is at the end of your Steam profile URL \r (e.g. http://steamcommunity.com/id/YOUR-VANITY-ID)"
        myAlertView.addButtonWithTitle("Dismiss")
        
        myAlertView.show()

    }
    var vanityUsername : String = ""
//    var steamID : String?

    // api is a lazy variable as only created when first used
    
//    lazy var api : SteamAPIController = SteamAPIController(delegate: self)
    
    @IBAction func saveVanityID(sender:AnyObject) {
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
    
    

//    func didReceiveAPIResults(steamIDReceived: NSDictionary) {
//        
//        if let response = steamIDReceived["response"] as? NSDictionary {
//            
//            
//            steamID = response["steamid"] as String?
//
//            println(steamID! + "id updated")
//
//            
//            // if success code is 1 then grab the steam id
////            if ((response["success"]) == "1") {
////                let steamID: String = jsonResult["steamid"] as String
////            }
////            // if success code is 42 then display alert saying there's no match
////            else if ((response["success"]) == "42") {
////                println("no id found")
////            }
////            // if success code is anything else, display alert blaming error on the server
////            else {
////                println("It's the server's fault")
////            }
//
//        }
//
//    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        var steamGamesNewsViewController: SteamGamesNewsViewController = segue.destinationViewController as SteamGamesNewsViewController
        vanityUsername = inputUsername.text

        steamGamesNewsViewController.toPass = vanityUsername

    }


    
}