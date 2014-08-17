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

class SteamAPIController {
    
    var delegate: SteamAPIControllerProtocol
    init(delegate: SteamAPIControllerProtocol) {
        self.delegate = delegate
    }
    
    func getSteamID(vanityid: String) {
        get ("http://api.steampowered.com/ISteamUser/ResolveVanityURL/v0001/?key=STEAM-KEY-HERE&vanityurl=\(vanityid)")
    }
    
    func getSteamGames(steamid: String) {
        get ("http://api.steampowered.com/IPlayerService/GetOwnedGames/v0001/?key=STEAM-KEY-HERE&steamid=\(steamid)&include_appinfo=1&format=json")
    }
    
    // get details
    func lookupNews(appid: String) {
        get("http://api.steampowered.com/ISteamNews/GetNewsForApp/v0002/?appid=\(appid)&count=3&maxlength=300&format=json")
    }
    
    func get(path: String) {
        let url = NSURL(string: path)
        // grab default NSURLSession object for use in networking calls
        let session = NSURLSession.sharedSession()
        
        // creates connection task to send request
        let task = session.dataTaskWithURL(url, completionHandler: {data, response, error -> Void in
            if(error) {
                // If there is an error in the web request, print it to the console
                println(error.localizedDescription)
            }
            var err: NSError?
            var jsonResult = NSJSONSerialization.JSONObjectWithData(data, options: NSJSONReadingOptions.MutableContainers, error: &err) as NSDictionary
            if(err?) {
                // If there is an error parsing JSON, print it to the console
                println("JSON Error \(err!.localizedDescription)")
            }
            
            // if we're getting a list of games, create gameResults list
            if (jsonResult["response"]) {
                let gameResults: NSDictionary = jsonResult["response"] as NSDictionary
            }
            // but if we're getting a list of newsitems for a game, create newsResults list instead
            else if (jsonResult["appnews"]) {
                let newsResults: NSDictionary = jsonResult["appnews"] as NSDictionary
            }
            
            self.delegate.didReceiveAPIResults(jsonResult)
            })
        
        // actually begin the request
        task.resume()
    }

}

