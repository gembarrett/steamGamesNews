//
//  SteamGamesNewsViewController.swift
//  SteamGamesNews
//
//  Created by Gemma Barrett on 02/08/2014.
//  Copyright (c) 2014 Gem Barrett. All rights reserved.
//

import UIKit
import QuartzCore

class SteamGamesNewsViewController: UIViewController, UITableViewDataSource, UITableViewDelegate, SteamAPIControllerProtocol {
    
    // connect table view in storyboard to variable appsTableView
    @IBOutlet var appsTableView : UITableView?

    let kCellIdentifier: String = "ResultCell"
    
    // create empty array containing only steam objects (list of games, news items, etc)
    var games = [Game]()

    // api is a lazy variable as only created when first used
    lazy var api : SteamAPIController = SteamAPIController(delegate: self)
    
    // take string as key and stores UIImage as a value
    var imageCache = [String : UIImage]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // network activity indicator
        UIApplication.sharedApplication().networkActivityIndicatorVisible = true
        
        // action the API calling function defined
        api.getSteamGames("76561198073968915")
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject) {
        // cast the steam object member to details view controller
        var steamDetailsViewController: SteamDetailsViewController = segue.destinationViewController as SteamDetailsViewController
        // work out which steam object is selected at the moment the segue happens
        var gameIndex = appsTableView!.indexPathForSelectedRow().row
        var selectedGame = self.games[gameIndex]
        steamDetailsViewController.game = selectedGame
    }
    
    
    func didReceiveAPIResults(gameResults: NSDictionary) {
        
        if let response = gameResults["response"] as? NSDictionary {
            if let games = response["games"] as? NSArray {
                
                dispatch_async(dispatch_get_main_queue(), {
                    self.games = Game.gamesWithJSON(games)
                    self.appsTableView!.reloadData()
                    UIApplication.sharedApplication().networkActivityIndicatorVisible = false
                    })
                
            }
        }
    }
    
    // how many rows in section
    func tableView(tableView: UITableView!, numberOfRowsInSection section: Int) -> Int {
        return games.count
    }
    
    // grab game name, small thumbnail and gameplay minutes for use in cell
    func tableView(tableView: UITableView!, cellForRowAtIndexPath indexPath: NSIndexPath!) -> UITableViewCell! {

        // create new instance of UITableViewCell using Subtitle cell style
        let cell: UITableViewCell = tableView.dequeueReusableCellWithIdentifier(kCellIdentifier) as UITableViewCell
        
        // check to make sure this item exists
        let game = self.games[indexPath.row]
        cell.textLabel.text = game.name
        cell.imageView.image = UIImage(named: "Blank52")
        
        // get gameplay mins for display in subtitle
        let gameplayMins = game.playingTime
        
        // go to background thread to get image for this item
        
        // get image url for thumbnail
        let urlString = game.thumbnailImageURL
                
        // check image cache for the existing key
        var image = self.imageCache[urlString]
        
        if( !image? ) {
            // If the image does not exist, we need to download it
            var imgURL: NSURL = NSURL(string: urlString)
            
            // Download an NSData representation of the image at the URL
            let request: NSURLRequest = NSURLRequest(URL: imgURL)
            NSURLConnection.sendAsynchronousRequest(request, queue: NSOperationQueue.mainQueue(), completionHandler: {(response: NSURLResponse!,data: NSData!,error: NSError!) -> Void in
                if !error? {
                    image = UIImage(data: data)
                    
                    // Store the image in to our cache
                    self.imageCache[urlString] = image
                    if let cellToUpdate = tableView.cellForRowAtIndexPath(indexPath) {
                        cellToUpdate.imageView.image = image
                    }
                }
                else {
                    println("Error: \(error.localizedDescription)")
                }
                })
            
        }
        else {
            dispatch_async(dispatch_get_main_queue(), {
                if let cellToUpdate = tableView.cellForRowAtIndexPath(indexPath) {
                    cellToUpdate.imageView.image = image
                }
            })
        }
        
        cell.detailTextLabel.text = gameplayMins
        
        return cell
    }


}

