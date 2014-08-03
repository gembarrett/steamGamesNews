//
//  SteamObject.swift
//  SteamGamesNews
//
//  Created by Gemma Barrett on 02/08/2014.
//  Copyright (c) 2014 Gem Barrett. All rights reserved.
//

import Foundation

class Game {
//    var title: String
//    var price: String
//    var thumbnailImageURL: String
//    var largeImageURL: String
//    var itemURL: String
//    var artistURL: String
//    var collectionId: Int
    
    var appid: String
    var name: String
    var thumbnailImageURL: String
    var largeImageURL: String

    init(appid: String, name: String, thumbnailImageURL: String, largeImageURL: String) {
        self.name = name
        self.appid = appid
        self.thumbnailImageURL = thumbnailImageURL
        self.largeImageURL = largeImageURL
    }
    
    class func gamesWithJSON(allResults: NSArray) -> [Game] {
        // empty array of Steam Objects to append to
        var games = [Game]()
        
        // store results in table data array
        if allResults.count > 0 {
            
            // check for collection or track
            for result in allResults {
                
                let name = result["name"] as? String

                let appid = result["appid"] as? String
                
                var thumbnailImageURL = result["img_icon_url"] as? String
                if (thumbnailImageURL == "") {
                    var thumbnailImageURL = "https://raw.githubusercontent.com/jquave/Swift-Tutorial/7a38913130a18594cc6bdf56ad4e1b4efe59c58e/HelloWorld/Blank52.png"
                }
                else {
                    var thumbnailImageURL = "http://cdn.akamai.steamstatic.com/steamcommunity/public/images/apps/\(appid)/\(thumbnailImageURL).jpg"
                }
                
                var largeImageURL = result["img_logo_url"] as? String
                if (largeImageURL == "") {
                    var largeImageURL = "https://raw.githubusercontent.com/jquave/Swift-Tutorial/7a38913130a18594cc6bdf56ad4e1b4efe59c58e/HelloWorld/Blank52.png"
                }
                else {
                    var largeImageURL = "http://cdn.akamai.steamstatic.com/steamcommunity/public/images/apps/\(appid)/\(largeImageURL).jpg"
                }
                
                
                var newGame = Game(appid: appid!, name: name!, thumbnailImageURL: thumbnailImageURL!, largeImageURL: largeImageURL!)
                
                games.append(newGame)
            }
        }
        return games
    }
}

