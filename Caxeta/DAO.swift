//
//  DAO.swift
//  Caxeta
//
//  Created by Alexandre Possebom on 31/12/15.
//  Copyright © 2015 Alexandre Possebom. All rights reserved.
//

import Foundation

public class DAO{
    static var players = [Player]()
    
    static func getPlayersWithPoints() -> [Player]{
        
        let playersWithPoints = players.filter { (p) -> Bool in
            p.points > 0
        }
        
        return playersWithPoints
    }
    
    static func containsUser(name:String) -> Bool{
        let n = players.filter { (p) -> Bool in
            p.name == name
        }
        return n.count > 0
    }
    
    static func getPlayersWillPlay() -> [Player]{
        let playPlayers = players.filter { (p) -> Bool in
            p.play && p.points > 0
        }
        return playPlayers
    }
    
    static func newGame(){
        _ = players.map { (p) -> Player in
            p.points = 10
            p.play = true
            return p
        }
    }
    
    static func calcRound(winner:Player){
        _ = players.map { (p) -> Player in
            if(p.play && p.name != winner.name){
                p.points -= 2
            }
            if(!p.play){
                p.points -= 1
            }
            p.play = true
            return p
        }
    }
    
}