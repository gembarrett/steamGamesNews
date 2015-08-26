//
//  SteamUserViewController.swift
//  SteamGamesNews
//
//  Created by Gemma Barrett on 13/09/2014.
//  Copyright (c) 2014 Gem Barrett. All rights reserved.
//

import Foundation
import UIKit
import SystemConfiguration

class SteamUserViewController: UIViewController {

    @IBOutlet weak var inputUsername: UITextField!
    @IBOutlet weak var submitUsername: UIButton!
    var vanityUsername : String = ""


    @IBAction func vanityidExplanation(sender: AnyObject) {
        var vanityIDAlert = UIAlertController(title: "What is my vanity ID?", message: "\r Your vanity ID is at the end of your Steam profile URL \r (e.g. http://steamcommunity.com/id/YOUR-VANITY-ID)", preferredStyle: UIAlertControllerStyle.Alert)
        vanityIDAlert.addAction(UIAlertAction(title: "Click", style: UIAlertActionStyle.Default, handler: nil))
        self.presentViewController(vanityIDAlert, animated: true, completion: nil)
    }
    

    @IBAction func saveVanityID(sender:AnyObject) {
        if inputUsername.text.isEmpty {
            // show alert asking for vanity name
            var errorAlert = UIAlertController(title: "Forgotten something?", message: "You need to enter a vanity ID in order to get the games list.", preferredStyle: .Alert)
            errorAlert.addAction(UIAlertAction(title: "Return", style: .Default, handler:nil))
            self.presentViewController(errorAlert, animated: true, completion: nil)
        }
        else {
            vanityUsername = inputUsername.text
        }

    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        var steamGamesNewsViewController: SteamGamesNewsViewController = segue.destinationViewController as! SteamGamesNewsViewController
        vanityUsername = inputUsername.text

        steamGamesNewsViewController.toPass = vanityUsername

    }


    
}