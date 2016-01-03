//
//  File.swift
//  Caxeta
//
//  Created by Alexandre Possebom on 28/12/15.
//  Copyright © 2015 Alexandre Possebom. All rights reserved.
//

import Foundation

public class Player: CustomStringConvertible{
    var name:String
    var points:Int = 10
    var play:Bool = true
    
    init(name:String){
        self.name = name
    }
    
    init(name:String, points:Int){
        self.name = name
        self.points = points
    }
    
    public var description: String {
        get{
            return "\(name) : \(points) : \(play)"
        }
    }
    
}

