//
//  File.swift
//  Caxeta
//
//  Created by Alexandre Possebom on 28/12/15.
//  Copyright © 2015 Alexandre Possebom. All rights reserved.
//

import Foundation

public class Player :Hashable{
    var name:String
    var points:Int = 10
    var play:Bool = true
    public var hashValue:Int
    
    init(name:String){
        self.name = name
        self.hashValue = name.hashValue
    }
    
}

public func ==(p1:Player,p2:Player) -> Bool{
    return p1.name == p2.name
}