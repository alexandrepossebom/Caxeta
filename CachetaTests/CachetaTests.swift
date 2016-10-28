//
//  CachetaTests.swift
//  CachetaTests
//
//  Created by Alexandre Possebom on 15/01/16.
//  Copyright © 2016 Alexandre Possebom. All rights reserved.
//

import XCTest
@testable import Cacheta

class CachetaTests: XCTestCase {

	override func setUp() {
		super.setUp()
		DAO.instance.players = [Player]()
		for _ in 1...5 {
			DAO.instance.addPlayer(randomAlphanumericString(10))
		}
	}

	override func tearDown() {
//        DAO.instance.players = [Player]()
//        DAO.instance.round = 1
//        DAO.instance.saveGame()
		// Put teardown code here. This method is called after the invocation of each test method in the class.
		super.tearDown()
	}

	func testExample() {
		DAO.instance.newGame()
		let p = DAO.instance.players.first

		for _ in 1...5 {
			DAO.instance.calcRound(p!)
		}

		print(DAO.instance.getPlayersWillPlay().count)
		XCTAssertTrue(DAO.instance.getPlayersWillPlay().count == 1)
	}


	func testRandomWinner() {
		DAO.instance.newGame()

		print(DAO.instance.players)

		while DAO.instance.getPlayersWillPlay().count > 1 {
			// This for always 1 player run
            var i = arc4random_uniform(UInt32(DAO.instance.players.count))
			DAO.instance.players[Int(i)].play = false

            // Winner
            i = arc4random_uniform(UInt32(DAO.instance.getPlayersWillPlay().count))
            let p = DAO.instance.getPlayersWillPlay() [Int(i)]

			DAO.instance.calcRound(p)

            print(DAO.instance.players)
		}

        print(DAO.instance.round)

		XCTAssertTrue(DAO.instance.getPlayersWillPlay().count == 1)
	}

	func randomAlphanumericString(_ length: Int) -> String {
		let letters = "abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ".characters
		let lettersLength = UInt32(letters.count)

		let randomCharacters = (0..<length).map { _ -> String in
			let offset = Int(arc4random_uniform(lettersLength))
			let c = letters[letters.index(letters.startIndex, offsetBy: offset)]
			return String(c)
		}

		return randomCharacters.joined(separator: "")
	}

}
