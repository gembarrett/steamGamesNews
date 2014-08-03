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
    
    func searchItunesFor(searchTerm: String) {
        
        // The iTunes API wants multiple terms separated by + symbols, so replace spaces with + signs
//        let itunesSearchTerm = searchTerm.stringByReplacingOccurrencesOfString(" ", withString: "+", options: NSStringCompareOptions.CaseInsensitiveSearch, range: nil)
        
        let steamID = 76561198073968915
        
        // Now escape anything else that isn't URL-friendly
//        let escapedSearchTerm = itunesSearchTerm.stringByAddingPercentEscapesUsingEncoding(NSUTF8StringEncoding)
        let urlPath = "http://api.steampowered.com/IPlayerService/GetOwnedGames/v0001/?key=STEAM-KEY-HERE&steamid=76561198073968915&include_appinfo=1&format=json"
        let url: NSURL = NSURL(string: urlPath)
        get (urlPath)
    }
    
    // get details
    func lookupAlbum(appid: String) {
        get("http://api.steampowered.com/ISteamNews/GetNewsForApp/v0002/?appid=\(appid)&count=3&maxlength=300&format=json")
    }
    
    func get(path: String) {
        let url = NSURL(string: path)
        // grab default NSURLSession object for use in networking calls
        let session = NSURLSession.sharedSession()
        
        // creates connection task to send request
        let task = session.dataTaskWithURL(url, completionHandler: {data, response, error -> Void in
            println("Task completed")
            println(url)
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
            let gameResults: NSDictionary = jsonResult["response"] as NSDictionary
            self.delegate.didReceiveAPIResults(jsonResult)
            })
        
        // actually begin the request
        task.resume()
    }

}

