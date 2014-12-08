//
//  SteamObjectDetails.swift
//  SteamGamesNews
//
//  Created by Gemma Barrett on 03/08/2014.
//  Copyright (c) 2014 Gem Barrett. All rights reserved.
//

import Foundation

class News {
    let title: String
    let url: String
    
    init(title: String, url: String) {
        self.title = title
        self.url = url
    }
    
    class func newsWithJSON(newsResults: NSArray) -> [News] {
        var news = [News]()
        
        if newsResults.count > 0 {
            for thisNews in newsResults {
                let newsTitle = thisNews["title"] as String
                let newsurl = thisNews["url"] as String
                
                let newsItem = News(title: newsTitle, url: newsurl)
                        
                news.append(newsItem)
            }
        }
        return news
    }
}