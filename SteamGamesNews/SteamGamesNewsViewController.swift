//
//  SteamGamesNewsViewController.swift
//  SteamGamesNews
//
//  Created by Gemma Barrett on 02/08/2014.
//  Copyright (c) 2014 Gem Barrett. All rights reserved.
//

import UIKit

class SteamGamesNewsViewController: UICollectionViewController, SteamAPIControllerProtocol {
    
    let kCellIdentifier: String = "GameCell"
    
    // create empty array containing only steam objects (list of games, news items, etc)
    var games = [Game]()
    
    // create variables for steam key and id
    let APIkey = "STEAM-KEY-HERE"
    var userID = "76561198073968915"

    // api is a lazy variable as only created when first used
    lazy var api : SteamAPIController = SteamAPIController(delegate: self)
    
    // take string as key and stores UIImage as a value
    var imageCache = [String : UIImage]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // network activity indicator
        UIApplication.sharedApplication().networkActivityIndicatorVisible = true
        
        // action the API calling function defined
        api.getSteamGames(APIkey, steamid: userID)
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // cast the steam object member to details view controller
        var steamDetailsViewController: SteamDetailsViewController = segue.destinationViewController as SteamDetailsViewController
        // work out which steam object is selected at the moment the segue happens
        var gameIndex = self.collectionView?.indexPathsForSelectedItems()[0].item
        var selectedGame = self.games[gameIndex!]
        steamDetailsViewController.game = selectedGame
    }
    
    
    func didReceiveAPIResults(gameResults: NSDictionary) {
        
        if let response = gameResults["response"] as? NSDictionary {
            if let games = response["games"] as? NSArray {
                
                dispatch_async(dispatch_get_main_queue(), {
                    self.games = Game.gamesWithJSON(games)
                    self.collectionView?.reloadData()
                    UIApplication.sharedApplication().networkActivityIndicatorVisible = false
                    })
                
            }
        }
    }
    
    override func collectionView(collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return games.count
    }

    override func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell {
        let cell: SteamGameCollectionViewCell = collectionView.dequeueReusableCellWithReuseIdentifier(kCellIdentifier, forIndexPath: indexPath) as SteamGameCollectionViewCell
        
        // check to make sure this item exists
        let game = self.games[indexPath.item]
        //        cell.gameName.text = game.name
        cell.gameLogo.image = UIImage(named: "Blank52")
        
        // get gameplay mins for display in subtitle
        //        let gameplayMins : String = "\(game.playingTime) mins"
        //        cell.timePlayed.text = gameplayMins
        
        // go to background thread to get image for this item
        
        // get image url for thumbnail
        let urlString = game.thumbnailImageURL
        
        // check image cache for the existing key
        var image = self.imageCache[urlString]
        
        if(image == nil) {
            // If the image does not exist, we need to download it
            var imgURL: NSURL = NSURL(string: urlString)
            
            // Download an NSData representation of the image at the URL
            let request: NSURLRequest = NSURLRequest(URL: imgURL)
            NSURLConnection.sendAsynchronousRequest(request, queue: NSOperationQueue.mainQueue(), completionHandler: {(response: NSURLResponse!,data: NSData!,error: NSError!) -> Void in
                if error == nil {
                    image = UIImage(data: data)
                    
                    // Store the image in to our cache
                    self.imageCache[urlString] = image
                    self.updateGameImage(image, indexPath)
                }
                else {
                    println("Error: \(error.localizedDescription)")
                }
            })
            
        } else {
            dispatch_async(dispatch_get_main_queue(), {
                self.updateGameImage(image, indexPath)
            })
        }
        
        return cell

    }
    
    
    func updateGameImage(image: UIImage?, _ indexPath: NSIndexPath) {
        if let cellToUpdate = collectionView?.cellForItemAtIndexPath(indexPath) as? SteamGameCollectionViewCell {
            cellToUpdate.gameLogo.image = image
        }
    }


}

