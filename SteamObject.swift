//
//  SteamObject.swift
//  SteamGamesNews
//
//  Created by Gemma Barrett on 02/08/2014.
//  Copyright (c) 2014 Gem Barrett. All rights reserved.
//

import Foundation

class Game {
    
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
                
                var name = result["name"] as String

                var appid : String = "\result['appid']"
                
                var playingTime : String = "\result['playtime_forever'] mins"
                
                var thumbnailImageURL = "http://cdn.akamai.steamstatic.com/steamcommunity/public/images/apps/\(appid)/\result['img_icon_url'].jpg"
                
                var largeImageURL = "http://cdn.akamai.steamstatic.com/steamcommunity/public/images/apps/\(appid)/\result['img_logo_url'].jpg"
                                
                var newGame = Game(appid: appid, name: name, thumbnailImageURL: thumbnailImageURL, largeImageURL: largeImageURL, playingTime: playingTime)
                
                games.append(newGame)
            }
        }
        return games
    }
}

