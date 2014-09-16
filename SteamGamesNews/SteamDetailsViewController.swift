//
//  SteamDetailsViewController.swift
//  SteamGamesNews
//
//  Created by Gemma Barrett on 02/08/2014.
//  Copyright (c) 2014 Gem Barrett. All rights reserved.
//

import Foundation
import UIKit

class SteamDetailsViewController: UIViewController, UITableViewDataSource, UITableViewDelegate, SteamAPIControllerProtocol {
    
    @IBOutlet weak var titleLabel: UINavigationItem!
//    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var gameImage: UIImageView!
    @IBOutlet weak var detailsTrackView: UITableView!

    var game: Game?
    var news = [News]()
    lazy var api : SteamAPIController = SteamAPIController(delegate: self)
    
    var refreshControl:UIRefreshControl!  // An optional variable

    
    required init(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // load in the info being passed through for selected steam object
        titleLabel.title = self.game?.name
        gameImage.image = UIImage(data: NSData(contentsOfURL: NSURL(string: self.game!.largeImageURL)))
        
        
        // pull down news items based on selected game
        if (self.game? != nil) {
            api.lookupNews(self.game!.appid)
        }
        
        self.refreshControl = UIRefreshControl()
        self.refreshControl.attributedTitle = NSAttributedString(string: "Pull to refresh")
        self.refreshControl.addTarget(self, action: "refresh:", forControlEvents: UIControlEvents.ValueChanged)
        self.detailsTrackView?.addSubview(refreshControl)


    }
    
    func refreshNews(sender:AnyObject) {
        // Code to refresh table view
        self.api.lookupNews(self.game!.appid)
    }

    func didReceiveAPIResults(newsResults: NSDictionary) {
        
        if let response = newsResults["appnews"] as? NSDictionary {
            if let news = response["newsitems"] as? NSArray {
                dispatch_async(dispatch_get_main_queue(), {
                    self.news = News.newsWithJSON(news)
                    self.detailsTrackView!.reloadData()
                    UIApplication.sharedApplication().networkActivityIndicatorVisible = false
                    })
                self.refreshControl.endRefreshing()
            }
        }
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return news.count
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        var cell = tableView.dequeueReusableCellWithIdentifier("NewsItemCell") as NewsItemCell
        
        var newsItem = news[indexPath.row]
        cell.titleLabel.text = newsItem.title
        return cell
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // send steam object to news web view controller
        var steamArticleViewController: SteamArticleViewController = segue.destinationViewController as SteamArticleViewController
        // work out which object is selected
        var newsIndex = detailsTrackView!.indexPathForSelectedRow()?.row
        var selectedNews = self.news[newsIndex!].url
        steamArticleViewController.selectedNews = selectedNews
    }
    

    
    func tableView(tableView: UITableView!, didSelectRowAtIndexPath indexPath:NSIndexPath!) {
        var newsItem = news[indexPath.row]
    }
    

}
