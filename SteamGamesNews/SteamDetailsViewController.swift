//
//  SteamDetailsViewController.swift
//  SteamGamesNews
//
//  Created by Gemma Barrett on 02/08/2014.
//  Copyright (c) 2014 Gem Barrett. All rights reserved.
//

import Foundation
import UIKit
import QuartzCore

class SteamDetailsViewController: UIViewController, UITableViewDataSource, UITableViewDelegate, SteamAPIControllerProtocol {
    
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var albumCover: UIImageView!
    @IBOutlet weak var detailsTrackView: UITableView!

    var game: Game?
    var news = [News]()
    lazy var api : SteamAPIController = SteamAPIController(delegate: self)
    
    init(coder aDecoder: NSCoder!) {
        super.init(coder: aDecoder)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // load in the info being passed through for selected steam object
        titleLabel.text = self.game?.name
        albumCover.image = UIImage(data: NSData(contentsOfURL: NSURL(string: self.game?.largeImageURL)))
        
        
        // pull down tracks based on selected album
        if self.game? {
            api.lookupAlbum(self.game!.appid)
        }
    }
    
    
    func didReceiveAPIResults(games: NSDictionary) {
        var resultsArr: NSArray = games["games"] as NSArray
        dispatch_async(dispatch_get_main_queue(), {
            self.news = News.newsWithJSON(resultsArr)
            self.detailsTrackView!.reloadData()
            UIApplication.sharedApplication().networkActivityIndicatorVisible = false
            })
    }

    
    func tableView(tableView: UITableView!, numberOfRowsInSection section: Int) -> Int {
        return news.count
    }
    
    func tableView(tableView: UITableView!, cellForRowAtIndexPath indexPath: NSIndexPath!) -> UITableViewCell! {
        var cell = tableView.dequeueReusableCellWithIdentifier("TrackCell") as TrackCell
        
        var newsItem = news[indexPath.row]
        cell.titleLabel.text = newsItem.title
        
        return cell
    }
    
    func tableView(tableView: UITableView!, didSelectRowAtIndexPath indexPath:NSIndexPath!) {
        var newsItem = news[indexPath.row]
//        // stop current track
//        mediaPlayer.stop()
//        // get content from this url
//        mediaPlayer.contentURL = NSURL(string: track.previewUrl)
//        mediaPlayer.play()
//        // get track cell for tapped row index
//        if let cell = tableView.cellForRowAtIndexPath(indexPath) as? TrackCell {
//            cell.playIcon.text = "◾️"
//        }
    }
    
    func tableView(tableView: UITableView!, willDisplayCell cell: UITableViewCell!, forRowAtIndexPath indexPath: NSIndexPath!) {
        cell.layer.transform = CATransform3DMakeScale(0.1, 0.1, 1)
        UIView.animateWithDuration(0.25, animations: {
            cell.layer.transform = CATransform3DMakeScale(1, 1, 1)
            })
    }

}
