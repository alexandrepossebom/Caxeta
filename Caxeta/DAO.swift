//
//  DAO.swift
//  Caxeta
//
//  Created by Alexandre Possebom on 31/12/15.
//  Copyright © 2015 Alexandre Possebom. All rights reserved.
//

import Foundation

public class DAO{
    
    static let instance = DAO()
    
    var players = [Player]()
    var playersWithPoints:[Player]?
    var playersWillPlay:[Player]?
    
    func getPlayersWithPoints() -> [Player]{
        if(playersWithPoints == nil){
            playersWithPoints = players.filter { (p) -> Bool in
                p.points > 0
            }
        }
        return playersWithPoints!
    }
    
    func addPlayer(name:String){
        if(!containsUser(name)){
            players.append(Player(name:name))
            invalidate()
            saveGame()
        }
    }
    
    func delPlayer(player:Player){
        players = players.filter { (p) -> Bool in
            p.name != player.name
        }
        invalidate()
    }
    
    internal func invalidate(){
        playersWithPoints = nil
        playersWillPlay = nil
    }
    
    internal func containsUser(name:String) -> Bool{
        let n = players.filter { (p) -> Bool in
            p.name == name
        }
        return n.count > 0
    }
    
    func getPlayersWillPlay() -> [Player]{
        if(playersWillPlay == nil){
            playersWillPlay = players.filter { (p) -> Bool in
                p.play && p.points > 0
            }
        }
        return playersWillPlay!
    }
    
    func newGame(){
        _ = players.map { (p) -> Player in
            p.points = 10
            p.play = true
            return p
        }
        invalidate()
    }
    
    func calcRound(winner:Player){
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
        invalidate()
        saveGame()
    }
    
    func loadGame(){
        if let game = NSUserDefaults().arrayForKey("Players") as? [[String:AnyObject]] {
            for item in game {
                let name = item["name"]! as! String
                let points = item["points"]! as! Int
                
                players.append(Player(name: name, points: points))
            }
        }
        
        invalidate()
    }
    
    func saveGame(){
        var save:[[String:AnyObject]] = []
        
        for p in players{
            save.append(["name":p.name,"points":p.points])
        }
        
        NSUserDefaults().setObject(save, forKey: "Players")
    }
    
}