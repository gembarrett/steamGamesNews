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
    
    var toPass:String!
    var steamid:String?
    
    // create empty array containing only steam objects (list of games, news items, etc)
    var games = [Game]()
    
    // api is a lazy variable as only created when first used
    lazy var api : SteamAPIController = SteamAPIController(delegate: self)
    
    // take string as key and stores UIImage as a value
    var imageCache = [String : UIImage]()
    

    override func viewDidAppear(animated: Bool) {
        super.viewDidAppear(animated)
        
        navigationController?.hidesBarsOnSwipe = true
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // network activity indicator
        UIApplication.sharedApplication().networkActivityIndicatorVisible = true
        // action the API calling function defined
        
        var vanityUsername = toPass
        
        api.getSteamID(APIkey, vanityid: vanityUsername)
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // cast the steam object member to details view controller
        
        let steamDetailsViewController = segue.destinationViewController as SteamDetailsViewController
        
        // work out which steam object is selected at the moment the segue happens
        var gameIndex = self.collectionView?.indexPathsForSelectedItems()[0].item
        var selectedGame = self.games[gameIndex!]
        steamDetailsViewController.game = selectedGame
    }
    
    
    func didReceiveAPIResults(gameResults: NSDictionary) {
        
        if let response = gameResults["response"] as? NSDictionary {
            
                if (response["success"] != nil) {
                    
                    let successCode = response["success"] as Int
                    switch successCode {
                        case 1:
                            println("we got a steam id")
                            self.steamid = response["steamid"] as? String
                            if let steamid = self.steamid{
                                self.api.getSteamGames(APIkey, steamid: self.steamid!)
                            }
                        case 42:
                            println("no id match")
                            let errorMessage = response["message"] as String
                            var errorAlert = UIAlertController(title: "Something went wrong!", message: errorMessage, preferredStyle: .Alert)
                            errorAlert.addAction(UIAlertAction(title: "Return", style: .Default, handler:nil))
                            self.presentViewController(errorAlert, animated: true, completion: nil)
                        default:
                            println("neither a 1 nor a 42 - I don't know wtf is going on")
                    } // end of switch
                    

                }
            
                // check that a user has games!
                if (response["game_count"] != nil) {
                    let gamesCount = response["game_count"] as Int
                    // if games list has been returned, add to array
                    if let games = response["games"] as? NSArray {
                        dispatch_async(dispatch_get_main_queue(), {
                            self.games = Game.gamesFromJSON(games)
                            self.collectionView?.reloadData()
                            UIApplication.sharedApplication().networkActivityIndicatorVisible = false
                        })
                    }
                    else if (gamesCount == 0) {
                        var errorAlert = UIAlertController(title: "Oh no!", message: "You don't have any games! Go buy some or enter another vanity ID.", preferredStyle: .Alert)
                        errorAlert.addAction(UIAlertAction(title: "Return", style: .Default, handler:nil))
                        self.presentViewController(errorAlert, animated: true, completion: nil)
                    }
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
        
        // cell.gameName.text = game.name
        cell.gameLogo.image = UIImage(named: "Blank52")
        
        // get image url for thumbnail
        let urlString = game.thumbnailImageURL
        
        // check image cache for the existing key
        var image = self.imageCache[urlString]
        
        
        // TODO: refactor into a separate method and set images after configuring rest of cell
        if(image == nil) {
            // If the image does not exist, we need to download it
            var imgURL: NSURL = NSURL(string: urlString)!
            
            // Download an NSData representation of the image at the URL
            let request: NSURLRequest = NSURLRequest(URL: imgURL)
            NSURLConnection.sendAsynchronousRequest(request, queue: NSOperationQueue.mainQueue(), completionHandler: {(response: NSURLResponse!,data: NSData!,error: NSError!) -> Void in
                if error == nil {
                    image = UIImage(data: data)
                    
                    if image == nil {
                        image = UIImage(named: "Blank52")
                        println(game.largeImageURL)
                    }
                    else {
                        // Store the image in to our cache
                        self.imageCache[urlString] = image
                        self.updateGameImage(image, indexPath)
                    }
                    
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

