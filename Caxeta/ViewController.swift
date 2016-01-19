//
//  ViewController.swift
//  Caxeta
//
//  Created by Alexandre Possebom on 28/12/15.
//  Copyright © 2015 Alexandre Possebom. All rights reserved.
//

import UIKit


class ViewController: UIViewController, UITableViewDataSource, UITableViewDelegate, DZNEmptyDataSetSource, DZNEmptyDataSetDelegate {


    @IBOutlet weak var tabletView: UITableView!
    @IBOutlet weak var editButton: UIBarButtonItem!

    var deletePlayerIndexPath: NSIndexPath? = nil

    override func viewDidLoad() {
        super.viewDidLoad()

        navigationItem.leftBarButtonItem = editButtonItem()

        tabletView.emptyDataSetSource = self
        tabletView.emptyDataSetDelegate = self

        // For dont show separator for empty cells
        self.tabletView.tableFooterView = UIView()
    }

    func tableView(tableView: UITableView, willDisplayCell cell: UITableViewCell, forRowAtIndexPath indexPath: NSIndexPath) {
        cell.separatorInset = UIEdgeInsetsZero
        cell.layoutMargins = UIEdgeInsetsZero
        cell.preservesSuperviewLayoutMargins = false
    }

    @IBAction func addPlayer(sender: UIButton) {

        let newPlayer = NSLocalizedString("new player", comment: "New player")
        let enterPlayerName = NSLocalizedString("input name", comment: "Enter the player name")

        let alert = UIAlertController(title: newPlayer, message: enterPlayerName, preferredStyle: .Alert)

        alert.addTextFieldWithConfigurationHandler {(textField) -> Void in
            textField.autocapitalizationType = .Words
        }

        alert.addAction(UIAlertAction(title: "OK", style: .Default, handler: {
            (action) -> Void in
            let textField = alert.textFields![0] as UITextField
            let name = textField.text!

            guard name.characters.count > 0 else {
                return
            }

            if DAO.instance.addPlayer(name) {
                // Update Table Data
                self.tabletView.beginUpdates()
                let lastRow = DAO.instance.players.count - 1
                let indexPath = NSIndexPath(forRow: lastRow, inSection: 0)
                self.tabletView.insertRowsAtIndexPaths([indexPath], withRowAnimation: .Automatic)
                self.tabletView.endUpdates()
            }

        }))

        self.presentViewController(alert, animated: true, completion: nil)
    }

    @IBAction func newGame(sender: UIButton) {

        let newGame = NSLocalizedString("new game", comment: "New Game")
        let newGameMessage = NSLocalizedString("new game message", comment: "Are you sure to start a new Game?")

        let yes = NSLocalizedString("yes", comment: "Yes")
        let cancel = NSLocalizedString("cancel", comment: "Cancel")

        let alert = UIAlertController(title: newGame, message: newGameMessage, preferredStyle: .ActionSheet)

        let YesAction = UIAlertAction(title: yes, style: .Destructive, handler: {
            (action) -> Void in
            DAO.instance.newGame()
            self.tabletView.reloadData()
        })
        let CancelAction = UIAlertAction(title: cancel, style: .Cancel, handler: nil)

        alert.addAction(YesAction)
        alert.addAction(CancelAction)

        self.presentViewController(alert, animated: true, completion: nil)
    }

    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        // swiftlint:disable:next force_cast
        let cell = tableView.dequeueReusableCellWithIdentifier("CellPlayer", forIndexPath: indexPath) as! PlayerTableViewCell


        cell.player = DAO.instance.players[indexPath.row]
        cell.labelNome.text = cell.player!.name
        cell.labelPoints.text = "\(cell.player!.points)"

        cell.buttonPlayOrRun.selectedSegmentIndex = cell.player!.play ? 0 : 1
        cell.buttonPlayOrRun.setEnabled(cell.player!.points == 1 ? false : true, forSegmentAtIndex: 1)


        cell.buttonPlayOrRun.hidden = (cell.player!.points == 0)

        if cell.player!.points == 0 {
            cell.contentView.backgroundColor = UIColor.lightGrayColor()
        } else {
            cell.contentView.backgroundColor = UIColor.clearColor()
        }


        return cell
    }

    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return DAO.instance.players.count
    }

    override func viewDidAppear(animated: Bool) {
        self.tabletView.reloadData()
    }

    func tableView(tableView: UITableView, commitEditingStyle editingStyle: UITableViewCellEditingStyle, forRowAtIndexPath indexPath: NSIndexPath) {
        if editingStyle == .Delete {
            deletePlayerIndexPath = indexPath
            let playerToDelete = DAO.instance.players[indexPath.row]
            confirmDelete(playerToDelete)
        }
    }

    func handleDeletePlayer(alertAction: UIAlertAction!) -> Void {
        if let indexPath = deletePlayerIndexPath {
            tabletView.beginUpdates()

            let playerToDelete = DAO.instance.players[indexPath.row]

            DAO.instance.delPlayer(playerToDelete)

            // Note that indexPath is wrapped in an array:  [indexPath]
            tabletView.deleteRowsAtIndexPaths([indexPath], withRowAnimation: .Automatic)

            deletePlayerIndexPath = nil

            tabletView.endUpdates()
        }
    }

    func tableView(tableView: UITableView, canMoveRowAtIndexPath indexPath: NSIndexPath) -> Bool {
        return true
    }

    override func setEditing(editing: Bool, animated: Bool) {
        super.setEditing(editing, animated: animated)
        tabletView.setEditing(editing, animated: true)
    }

    func tableView(tableView: UITableView, moveRowAtIndexPath fromIndexPath: NSIndexPath, toIndexPath: NSIndexPath) {
        let playerToMove = DAO.instance.players[fromIndexPath.row]
        DAO.instance.players.removeAtIndex(fromIndexPath.row)
        DAO.instance.players.insert(playerToMove, atIndex: toIndexPath.row)
    }

    func confirmDelete(player: Player) {

        let deletePlayer = NSLocalizedString("delete player", comment: "Delete Player")
        let deletePlayerMessage = String.localizedStringWithFormat(NSLocalizedString("delete player message", comment: "Delete Player Message"), player.name)

        let delete = NSLocalizedString("delete", comment: "Delete")
        let cancel = NSLocalizedString("cancel", comment: "Cancel")

        let alert = UIAlertController(title: deletePlayer, message: deletePlayerMessage, preferredStyle: .ActionSheet)

        let DeleteAction = UIAlertAction(title: delete, style: .Destructive, handler: handleDeletePlayer)
        let CancelAction = UIAlertAction(title: cancel, style: .Cancel, handler: nil)

        alert.addAction(DeleteAction)
        alert.addAction(CancelAction)

        self.presentViewController(alert, animated: true, completion: nil)
    }

    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Force recalculate play will play
        DAO.instance.invalidate()
    }

    func titleForEmptyDataSet(scrollView: UIScrollView!) -> NSAttributedString! {
        let str = NSLocalizedString("no players", comment: "No players")
        let attrs = [NSFontAttributeName: UIFont.preferredFontForTextStyle(UIFontTextStyleHeadline)]
        return NSAttributedString(string: str, attributes: attrs)
    }

    func descriptionForEmptyDataSet(scrollView: UIScrollView!) -> NSAttributedString! {
        let str = NSLocalizedString("add some players", comment: "Add some players")
        let attrs = [NSFontAttributeName: UIFont.preferredFontForTextStyle(UIFontTextStyleBody)]
        return NSAttributedString(string: str, attributes: attrs)
    }

    func imageForEmptyDataSet(scrollView: UIScrollView!) -> UIImage! {
        return UIImage(named: "AppIcon60x60")
    }



}
