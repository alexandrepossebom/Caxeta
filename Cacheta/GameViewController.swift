//
//  GameViewController.swift
//  Cacheta
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

    override func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        cell.separatorInset = UIEdgeInsets.zero
        cell.layoutMargins = UIEdgeInsets.zero
        cell.preservesSuperviewLayoutMargins = false
    }

	override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        // swiftlint:disable:next force_cast
		let cell = tableView.dequeueReusableCell(withIdentifier: "CellPlayerGame", for: indexPath) as! GameTableViewCell

		cell.gameViewController = self
		cell.player = DAO.instance.getPlayersWillPlay() [(indexPath as NSIndexPath).row]
		cell.labelNome.text = cell.player!.name

		return cell
	}

	override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
		return DAO.instance.getPlayersWillPlay().count
	}

	func title(forEmptyDataSet scrollView: UIScrollView) -> NSAttributedString? {
		let str = NSLocalizedString("more players", comment: "More Players")
		let attrs = [NSFontAttributeName: UIFont.preferredFont(forTextStyle: UIFontTextStyle.headline)]
		return NSAttributedString(string: str, attributes: attrs)
	}

	func description(forEmptyDataSet scrollView: UIScrollView) -> NSAttributedString? {
		let str = NSLocalizedString("more players needed", comment: "More players needed")
		let attrs = [NSFontAttributeName: UIFont.preferredFont(forTextStyle: UIFontTextStyle.body)]
		return NSAttributedString(string: str, attributes: attrs)
	}

	func image(forEmptyDataSet scrollView: UIScrollView) -> UIImage? {
		return UIImage(named: "AppIcon60x60")
	}

    override func tableView(_ tableView: UITableView, shouldHighlightRowAt indexPath: IndexPath) -> Bool {
       return false
    }


}
