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
    
    @IBAction func changedPlayOrRun(sender: UISegmentedControl) {
        
        
        let play = (sender.selectedSegmentIndex == 0)
        
        if(play){
            print("play")
        }else{
            print("run")
        }
        
        _ = DAO.players.map { (p) -> Player in
            if(p.name == player?.name){
                p.play = play
            }
            return p
        }
        
        print(DAO.players)
        
        for p in DAO.players{
            print("\(p.name) : \(p.points) : \(p.play) ")
        }
        
    }

    
}
