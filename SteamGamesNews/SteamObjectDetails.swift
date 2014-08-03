//
//  SteamObjectDetails.swift
//  SteamGamesNews
//
//  Created by Gemma Barrett on 03/08/2014.
//  Copyright (c) 2014 Gem Barrett. All rights reserved.
//

import Foundation

class News {
    var title: String
    var appid: String
    var url: String
    
    init(title: String, appid: String, url: String) {
        self.title = title
        self.appid = appid
        self.url = url
    }
    
    class func newsWithJSON(allResults: NSArray) -> [News] {
        var newsItems = [News]()
        
        if allResults.count > 0 {
            for detailsInfo in allResults {
                // create the track
                if let kind = detailsInfo["kind"] as? String {
                    if kind == "song" {
                        var newsTitle = detailsInfo["title"] as? String
                        var newsAppid = detailsInfo["appid"] as? String
                        var newsurl = detailsInfo["url"] as? String
                        
                        if (!newsTitle) {
                            newsTitle = "Unknown"
                        }
                        else if (!newsAppid) {
                            println("No trackPrice in \(detailsInfo)")
                            newsAppid = "?"
                        }
                        else if (!newsurl) {
                            newsurl = ""
                        }
                        
                        var newsItem = News(title: newsTitle!, appid: newsAppid!, url: newsurl!)
                        
                        newsItems.append(newsItem)
                    }
                }
            }
        }
        return newsItems
    }
}