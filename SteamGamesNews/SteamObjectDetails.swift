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
    var url: String
    
    init(title: String, url: String) {
        self.title = title
        self.url = url
    }
    
    class func newsWithJSON(allResults: NSArray) -> [News] {
        var newsItems = [News]()
        
        if allResults.count > 0 {
            for detailsInfo in allResults {
                var newsTitle = detailsInfo["title"] as? String
                var newsurl = detailsInfo["url"] as? String
                        
                if (newsTitle == nil) {
                    newsTitle = "Unknown"
                }
                else if (newsurl == nil) {
                    newsurl = ""
                }
                        
                var newsItem = News(title: newsTitle!, url: newsurl!)
                        
                newsItems.append(newsItem)
            }
        }
        return newsItems
    }
}