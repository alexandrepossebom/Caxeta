//
//  DAO.swift
//  Caxeta
//
//  Created by Alexandre Possebom on 31/12/15.
//  Copyright © 2015 Alexandre Possebom. All rights reserved.
//
import Foundation

public class DAO {
	
	static let instance = DAO()
	
	var round = 1
	var players = [Player]()
	var playersWithPoints: [Player]?
	var playersWillPlay: [Player]?
	
	func addPlayer(name: String) -> Bool {
		if containsUser(name) {
			return false
		}
		players.append(Player(name: name))
		invalidate()
		saveGame()
		return true
	}
	
	func delPlayer(player: Player) {
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
	
	internal func containsUser(name: String) -> Bool {
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
	
	func calcRound(winner: Player) {
		_ = players.map {(player) -> Player in
			if player.play && player.name != winner.name {
				player.points -= 2
			} else if !player.play {
				player.points -= 1
			}
			player.play = true
			return player
		}
		round++
		invalidate()
		saveGame()
	}
	
	func loadGame() {
		if let game = NSUserDefaults().arrayForKey("Players") as? [[String: AnyObject]] {
			for item in game {
				let name = item["name"]! as! String
				let points = item["points"]! as! Int
				
				players.append(Player(name: name, points: points))
			}
		}
		
		round = NSUserDefaults().integerForKey("round")
		if round == 0 {
			round = 1
		}
		
		invalidate()
	}
	
	func saveGame() {
		var save: [[String: AnyObject]] = []
		
		for p in players {
			save.append(["name": p.name, "points": p.points])
		}
		NSUserDefaults().setInteger(round, forKey: "round")
		NSUserDefaults().setObject(save, forKey: "Players")
	}
	
}