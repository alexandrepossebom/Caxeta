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
        
        let winner = NSLocalizedString("winner", comment: "Winner")
        let winnerMessage = String.localizedStringWithFormat(NSLocalizedString("winner message", comment: "Winner"), player!.name)
        
        let yes = NSLocalizedString("yes", comment: "Yes")
        let no = NSLocalizedString("no", comment: "No")
        
        let alert = UIAlertController(title: winner, message: winnerMessage, preferredStyle: UIAlertControllerStyle.Alert)
        
        alert.addAction(UIAlertAction(title: no, style: .Cancel, handler: nil))
        alert.addAction(UIAlertAction(title: yes, style: .Destructive, handler: { (action: UIAlertAction!) in
            DAO.instance.calcRound(self.player!)
            self.gameViewController?.navigationController?.popViewControllerAnimated(true)
        }))
        
        gameViewController?.presentViewController(alert, animated: true, completion: nil)
    }
    
}
