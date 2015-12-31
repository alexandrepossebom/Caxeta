//
//  GameTableViewCell.swift
//  Caxeta
//
//  Created by Alexandre Possebom on 31/12/15.
//  Copyright © 2015 Alexandre Possebom. All rights reserved.
//

import UIKit
    
class GameTableViewCell: UITableViewCell {
    
     var player:Player?

    @IBOutlet weak var labelNome: UILabel!
    
    @IBAction func buttonWin(sender: UIButton) {
        DAO.calcRound(player!)
    }
    
}
