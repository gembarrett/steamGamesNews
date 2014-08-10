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
    var playingTime: String

    init(appid: String, name: String, thumbnailImageURL: String, largeImageURL: String, playingTime: String) {
        self.name = name
        self.appid = appid
        self.thumbnailImageURL = thumbnailImageURL
        self.largeImageURL = largeImageURL
        self.playingTime = playingTime
    }
    
    class func gamesWithJSON(allResults: NSArray) -> [Game] {
        // empty array of Steam Objects to append to
        var games = [Game]()
        
        // store results in table data array
        if allResults.count > 0 {
            
            // check for collection or track
            for result in allResults {
                
                let name = result["name"] as String

                let appInt = result["appid"] as Int
                var appid : String = "\(appInt)"
                
                let playingInt = result["playtime_forever"] as Int
                var playingTime : String = "\(playingInt) mins"
                
                var thumbnailImageID = result["img_icon_url"] as String
                var thumbnailImageURL = "http://cdn.akamai.steamstatic.com/steamcommunity/public/images/apps/\(appid)/\(thumbnailImageID).jpg"
                
                var largeImageID = result["img_logo_url"] as String
                var largeImageURL = "http://cdn.akamai.steamstatic.com/steamcommunity/public/images/apps/\(appid)/\(largeImageID).jpg"
                                
                var newGame = Game(appid: appid, name: name, thumbnailImageURL: thumbnailImageURL, largeImageURL: largeImageURL, playingTime: playingTime)
                
                games.append(newGame)
            }
        }
        return games
    }
}

