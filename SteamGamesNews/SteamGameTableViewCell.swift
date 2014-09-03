//
//  SteamGameTableViewCell.swift
//  SteamGamesNews
//
//  Created by Stuart McHattie on 03/09/2014.
//  Copyright (c) 2014 Gem Barrett. All rights reserved.
//

import UIKit

class SteamGameTableViewCell: UITableViewCell {

    @IBOutlet weak var gameImage: UIImageView!
    @IBOutlet weak var gameName: UILabel!
    @IBOutlet weak var timePlayed: UILabel!
    
    required init(coder aDecoder: NSCoder) {
        return super.init(coder: aDecoder);
    }
    
}
