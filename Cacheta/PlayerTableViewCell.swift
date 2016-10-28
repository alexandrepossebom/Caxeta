//
//  PlayerTableViewCell.swift
//  Cacheta
//
//  Created by Alexandre Possebom on 28/12/15.
//  Copyright © 2015 Alexandre Possebom. All rights reserved.
//

import UIKit

class PlayerTableViewCell: UITableViewCell {

	var player: Player?

	@IBOutlet weak var buttonPlayOrRun: UISegmentedControl!
	@IBOutlet weak var labelNome: UILabel!
	@IBOutlet weak var labelPoints: UILabel!

	@IBAction func changedPlayOrRun(_ sender: UISegmentedControl) {
		let play = (sender.selectedSegmentIndex == 0)
		_ = DAO.instance.players.map {(player) -> Player in
			if player.name == self.player?.name {
				player.play = play
			}
			return player
		}
	}

}
