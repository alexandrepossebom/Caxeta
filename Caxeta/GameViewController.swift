//
//  GameViewController.swift
//  Caxeta
//
//  Created by Alexandre Possebom on 31/12/15.
//  Copyright © 2015 Alexandre Possebom. All rights reserved.
//

import UIKit

class GameViewController: UITableViewController, DZNEmptyDataSetSource, DZNEmptyDataSetDelegate {

	override func viewDidLoad() {
		super.viewDidLoad()
		self.title = String.localizedStringWithFormat(NSLocalizedString("round", comment: "Round"), DAO.instance.round)

		tableView.emptyDataSetSource = self
		tableView.emptyDataSetDelegate = self

		// For dont show separator for empty cells
		self.tableView.tableFooterView = UIView()
	}

    override func tableView(tableView: UITableView, willDisplayCell cell: UITableViewCell, forRowAtIndexPath indexPath: NSIndexPath) {
        cell.separatorInset = UIEdgeInsetsZero
        cell.layoutMargins = UIEdgeInsetsZero
        cell.preservesSuperviewLayoutMargins = false
    }

	override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        // swiftlint:disable:next force_cast
		let cell = tableView.dequeueReusableCellWithIdentifier("CellPlayerGame", forIndexPath: indexPath) as! GameTableViewCell

		cell.gameViewController = self
		cell.player = DAO.instance.getPlayersWillPlay() [indexPath.row]
		cell.labelNome.text = cell.player!.name

		return cell
	}

	override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
		return DAO.instance.getPlayersWillPlay().count
	}

	func titleForEmptyDataSet(scrollView: UIScrollView!) -> NSAttributedString! {
		let str = NSLocalizedString("more players", comment: "More Players")
		let attrs = [NSFontAttributeName: UIFont.preferredFontForTextStyle(UIFontTextStyleHeadline)]
		return NSAttributedString(string: str, attributes: attrs)
	}

	func descriptionForEmptyDataSet(scrollView: UIScrollView!) -> NSAttributedString! {
		let str = NSLocalizedString("more players needed", comment: "More players needed")
		let attrs = [NSFontAttributeName: UIFont.preferredFontForTextStyle(UIFontTextStyleBody)]
		return NSAttributedString(string: str, attributes: attrs)
	}

	func imageForEmptyDataSet(scrollView: UIScrollView!) -> UIImage! {
		return UIImage(named: "AppIcon60x60")
	}


}
