//
//  GameTableViewCell.swift
//  Caxeta
//
//  Created by Alexandre Possebom on 31/12/15.
//  Copyright © 2015 Alexandre Possebom. All rights reserved.
//

import UIKit

class GameTableViewCell: UITableViewCell {

    var player: Player?
    var gameViewController: GameViewController?

    @IBOutlet weak var labelNome: UILabel!

    @IBAction func buttonWin(_ sender: UIButton) {

        let winner = NSLocalizedString("winner", comment: "Winner")
        let winnerMessage = String.localizedStringWithFormat(NSLocalizedString("winner message", comment: "Winner"), player!.name)

        let yes = NSLocalizedString("yes", comment: "Yes")
        let no = NSLocalizedString("no", comment: "No")

        let alert = UIAlertController(title: winner, message: winnerMessage, preferredStyle: UIAlertControllerStyle.alert)

        alert.addAction(UIAlertAction(title: no, style: .cancel, handler: nil))
        alert.addAction(UIAlertAction(title: yes, style: .destructive, handler: { (action: UIAlertAction!) in
            DAO.instance.calcRound(self.player!)
            self.gameViewController?.navigationController?.popViewController(animated: true)
        }))

        gameViewController?.present(alert, animated: true, completion: nil)
    }

}
