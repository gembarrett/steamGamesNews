//
//  SteamObject.swift
//  SteamGamesNews
//
//  Created by Gemma Barrett on 02/08/2014.
//  Copyright (c) 2014 Gem Barrett. All rights reserved.
//

import Foundation

class Game {
    
    let appid: String
    let name: String
    let thumbnailImageURL: String
    let largeImageURL: String
    let playingTime: Int

    init(appid: String, name: String, thumbnailImageURL: String, largeImageURL: String, playingTime: Int) {
        self.name = name
        self.appid = appid
        self.thumbnailImageURL = thumbnailImageURL
        self.largeImageURL = largeImageURL
        self.playingTime = playingTime
    }
    
    class func gamesWithJSON(gameResults: NSArray) -> [Game] {
        // empty array of Steam Objects to append to
        var games = [Game]()
        
        // store results in table data array
        if gameResults.count > 0 {
            
            // check for gameResults or track
            for thisGame in gameResults {
                
                let name = thisGame["name"] as String

                let appInt = thisGame["appid"] as Int
                let appid : String = "\(appInt)"
                
                let playingTime = thisGame["playtime_forever"] as Int
                                
                let thumbnailImageID = thisGame["img_icon_url"] as String
                let thumbnailImageURL = "http://cdn.akamai.steamstatic.com/steam/apps/\(appid)/capsule_184x69.jpg"
                
                let largeImageID = thisGame["img_logo_url"] as String
                let largeImageURL = "http://cdn.akamai.steamstatic.com/steam/apps/\(appid)/header.jpg"
                                
                let newGame = Game(appid: appid, name: name, thumbnailImageURL: thumbnailImageURL, largeImageURL: largeImageURL, playingTime: playingTime)
                
                games.append(newGame)
            }
            // sort games by playing time so most popular games at top
            games = games.sorted {$0.playingTime > $1.playingTime}
        }
        return games
    }
}

