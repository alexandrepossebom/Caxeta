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
    
    static func containsUser(name:String) -> Bool{
        let runningPlayers = players.filter { (p) -> Bool in
            p.name == name
        }
        return runningPlayers.count > 0
    }
    
    static var runningPlayers = players.filter { (p) -> Bool in
        p.play
    }
    
    static func calcRound(winner:Player){
        _ = players.map { (p) -> Player in
            if(p.play && p.name != winner.name){
                p.points -= 2
            }
            return p
        }
    }
    
}