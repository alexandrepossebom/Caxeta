//
//  File.swift
//  Caxeta
//
//  Created by Alexandre Possebom on 28/12/15.
//  Copyright © 2015 Alexandre Possebom. All rights reserved.
//

import Foundation

public class Player: CustomStringConvertible {
	var name: String
    var play: Bool = true
    
	var points: Int = 10 {
        didSet {
            if points == 1 {
                play = true
            } else if points < 1 {
                points = 0
                play = false
            }
        }
	}
	
	init(name: String) {
		self.name = name
	}
	
	init(name: String, points: Int) {
		self.name = name
		self.points = points
	}
	
	public var description: String {
		get {
			return "\(name) : \(points) : \(play)"
		}
	}
	
}
