//
//  SteamAPIController.swift
//  SteamGamesNews
//
//  Created by Gemma Barrett on 02/08/2014.
//  Copyright (c) 2014 Gem Barrett. All rights reserved.
//

import Foundation

// protocol for declaring function didReceiveAPIResults
protocol SteamAPIControllerProtocol {
    func didReceiveAPIResults(gameResults: NSDictionary)
}

var APIkey : String = "STEAM-KEY-HERE"
var steamid : String?

class SteamAPIController {
    
    var delegate: SteamAPIControllerProtocol
    init(delegate: SteamAPIControllerProtocol) {
        self.delegate = delegate
    }
    
    func getSteamID(steamkey: String, vanityid: String) {
        get ("http://api.steampowered.com/ISteamUser/ResolveVanityURL/v0001/?key=\(steamkey)&vanityurl=\(vanityid)")
    }
    
    func getSteamGames(steamkey: String, steamid: String) {
        get ("http://api.steampowered.com/IPlayerService/GetOwnedGames/v0001/?key=\(steamkey)&steamid=\(steamid)&include_appinfo=1&format=json")
    }
    
    // get details
    func lookupNews(appid: String) {
        get("http://api.steampowered.com/ISteamNews/GetNewsForApp/v0002/?appid=\(appid)&count=10&maxlength=150&format=json")
    }
    
    func get(path: String) {
        let url = NSURL(string: path)
        // grab default NSURLSession object for use in networking calls
        let session = NSURLSession.sharedSession()
        
        // creates connection task to send request
        let task = session.dataTaskWithURL(url!, completionHandler: {data, response, error -> Void in
            if((error) != nil) {
                // If there is an error in the web request, print it to the console
                println(error.localizedDescription)
            }
            var err: NSError?
            var jsonResult = NSJSONSerialization.JSONObjectWithData(data, options: NSJSONReadingOptions.MutableContainers, error: &err) as NSDictionary
            if((err) != nil) {
                // If there is an error parsing JSON, print it to the console
                println("JSON Error \(err!.localizedDescription)")
            }
            
            // if we're getting a list of games or a steamID
            if ((jsonResult["response"]) != nil) {
                    println(jsonResult["response"])
                    // create gameResults list
                    let gameResults: NSDictionary = jsonResult["response"] as NSDictionary
            }
            // but if we're getting a list of newsitems for a game, create newsResults list instead
            else if ((jsonResult["appnews"]) != nil) {
                let newsResults: NSDictionary = jsonResult["appnews"] as NSDictionary
//                let newsResults: NSArray = appnews["newsitems"] as NSArray
            }
            self.delegate.didReceiveAPIResults(jsonResult)
        })
        
        // actually begin the request
        task.resume()
    }

}

