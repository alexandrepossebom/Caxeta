//
//  DAO.swift
//  Caxeta
//
//  Created by Alexandre Possebom on 31/12/15.
//  Copyright © 2015 Alexandre Possebom. All rights reserved.
//
import Foundation

open class DAO {

	static let instance = DAO()

	var round = 1
	var players = [Player]()
	var playersWithPoints: [Player]?
	var playersWillPlay: [Player]?

	func addPlayer(_ name: String) -> Bool {
		if containsUser(name) {
			return false
		}
		players.append(Player(name: name))
		invalidate()
		saveGame()
		return true
	}

	func delPlayer(_ player: Player) {
        let name = player.name
		players = players.filter {(player) -> Bool in
			player.name != name
		}
		invalidate()
		saveGame()
	}

	internal func invalidate() {
		playersWithPoints = nil
		playersWillPlay = nil
	}

	internal func containsUser(_ name: String) -> Bool {
		let n = players.filter {(player) -> Bool in
			player.name == name
		}
		return n.count > 0
	}

	func getPlayersWillPlay() -> [Player] {
		if playersWillPlay == nil {
			playersWillPlay = players.filter {(player) -> Bool in
				player.play && player.points > 0
			}
		}
		return playersWillPlay!
	}

	func newGame() {
		_ = players.map {(player) -> Player in
			player.points = 10
			player.play = true
			return player
		}
		round = 1
		invalidate()
	}

	func calcRound(_ winner: Player) {
		_ = players.map {(player) -> Player in
			if player.play && player.name != winner.name {
				player.points -= 2
			} else if !player.play {
				player.points -= 1
			}
			player.play = true
			return player
		}
		round += 1
		invalidate()
		saveGame()
	}

	func loadGame() {
		if let game = UserDefaults().array(forKey: "Players") as? [[String: AnyObject]] {
			for item in game {

                guard let name = item["name"]! as? String else {
                    return
                }

                guard let points = item["points"]! as? Int else {
                    return
                }

				players.append(Player(name: name, points: points))
			}
		}

		round = UserDefaults().integer(forKey: "round")
		if round == 0 {
			round = 1
		}

		invalidate()
	}

	func saveGame() {
		var save: [[String: AnyObject]] = []

		for p in players {
			save.append(["name": p.name as AnyObject, "points": p.points as AnyObject])
		}
		UserDefaults().set(round, forKey: "round")
		UserDefaults().set(save, forKey: "Players")
	}

}
