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
    var gameViewController:GameViewController?
    
    @IBOutlet weak var labelNome: UILabel!
    
    @IBAction func buttonWin(sender: UIButton) {
        let alert = UIAlertController(title: "Winner", message: "\(player!.name) is the winner?", preferredStyle: UIAlertControllerStyle.Alert)
        
        alert.addAction(UIAlertAction(title: "No", style: .Cancel, handler: nil))
        alert.addAction(UIAlertAction(title: "Yes", style: .Destructive, handler: { (action: UIAlertAction!) in
            DAO.calcRound(self.player!)
            self.gameViewController?.navigationController?.popViewControllerAnimated(true)
        }))
        
        gameViewController?.presentViewController(alert, animated: true, completion: nil)
    }
    
}
