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
    

    
    @IBAction func saveVanityID(sender:AnyObject) {
        if inputUsername.text.isEmpty {
            // show alert asking for vanity name
            println("No vanity name entered")
        }
        else {
            vanityUsername = inputUsername.text
        }

    }
    
        var vanityUsername : String = ""

    override func viewDidLoad() {
        super.viewDidLoad()
        
    }
    
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        var steamGamesNewsViewController: SteamGamesNewsViewController = segue.destinationViewController as SteamGamesNewsViewController
        vanityUsername = inputUsername.text

        steamGamesNewsViewController.toPass = vanityUsername

    }


    
}