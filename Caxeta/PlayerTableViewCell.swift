//
//  PlayerTableViewCell.swift
//  Caxeta
//
//  Created by Alexandre Possebom on 28/12/15.
//  Copyright © 2015 Alexandre Possebom. All rights reserved.
//

import UIKit

class PlayerTableViewCell: UITableViewCell {
    
    var player:Player?

    @IBOutlet weak var labelNome: UILabel!
    
    @IBAction func buttonTouched(sender: UIButton) {
        print(player!.name)
    }
    
}
