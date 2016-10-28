//
//  ViewController.swift
//  Cacheta
//
//  Created by Alexandre Possebom on 28/12/15.
//  Copyright © 2015 Alexandre Possebom. All rights reserved.
//

import UIKit


class ViewController: UIViewController, UITableViewDataSource, UITableViewDelegate, DZNEmptyDataSetSource, DZNEmptyDataSetDelegate {


    @IBOutlet weak var tabletView: UITableView!
    @IBOutlet weak var editButton: UIBarButtonItem!

    var deletePlayerIndexPath: IndexPath? = nil

    override func viewDidLoad() {
        super.viewDidLoad()

        navigationItem.leftBarButtonItem = editButtonItem

        tabletView.emptyDataSetSource = self
        tabletView.emptyDataSetDelegate = self

//        self.edgesForExtendedLayout = UIRectEdge(rawValue: 0)
        // For dont show separator for empty cells
        self.tabletView.tableFooterView = UIView()
    }

    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        cell.separatorInset = UIEdgeInsets.zero
        cell.layoutMargins = UIEdgeInsets.zero
        cell.preservesSuperviewLayoutMargins = false
    }

    @IBAction func addPlayer(_ sender: UIButton) {

        let newPlayer = NSLocalizedString("new player", comment: "New player")
        let enterPlayerName = NSLocalizedString("input name", comment: "Enter the player name")

        let alert = UIAlertController(title: newPlayer, message: enterPlayerName, preferredStyle: .alert)

        alert.addTextField {(textField) -> Void in
            textField.autocapitalizationType = .words
        }

        alert.addAction(UIAlertAction(title: "OK", style: .default, handler: {
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
                let indexPath = IndexPath(row: lastRow, section: 0)
                self.tabletView.insertRows(at: [indexPath], with: .automatic)
                self.tabletView.endUpdates()
            }

        }))

        self.present(alert, animated: true, completion: nil)
    }

    @IBAction func newGame(_ sender: UIButton) {

        let newGame = NSLocalizedString("new game", comment: "New Game")
        let newGameMessage = NSLocalizedString("new game message", comment: "Are you sure to start a new Game?")

        let yes = NSLocalizedString("yes", comment: "Yes")
        let cancel = NSLocalizedString("cancel", comment: "Cancel")

        let alert = UIAlertController(title: newGame, message: newGameMessage, preferredStyle: .actionSheet)

        let YesAction = UIAlertAction(title: yes, style: .destructive, handler: {
            (action) -> Void in
            DAO.instance.newGame()
            self.tabletView.reloadData()
        })
        let CancelAction = UIAlertAction(title: cancel, style: .cancel, handler: nil)

        alert.addAction(YesAction)
        alert.addAction(CancelAction)

        self.present(alert, animated: true, completion: nil)
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        // swiftlint:disable:next force_cast
        let cell = tableView.dequeueReusableCell(withIdentifier: "CellPlayer", for: indexPath) as! PlayerTableViewCell


        cell.player = DAO.instance.players[(indexPath as NSIndexPath).row]
        cell.labelNome.text = cell.player!.name
        cell.labelPoints.text = "\(cell.player!.points)"

        cell.buttonPlayOrRun.selectedSegmentIndex = cell.player!.play ? 0 : 1
        cell.buttonPlayOrRun.setEnabled(cell.player!.points == 1 ? false : true, forSegmentAt: 1)


        cell.buttonPlayOrRun.isHidden = (cell.player!.points == 0)

        if cell.player!.points == 0 {
            cell.contentView.backgroundColor = UIColor.lightGray
        } else {
            cell.contentView.backgroundColor = UIColor.clear
        }


        return cell
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return DAO.instance.players.count
    }

    override func viewDidAppear(_ animated: Bool) {
        self.tabletView.reloadData()
    }

    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            deletePlayerIndexPath = indexPath
            let playerToDelete = DAO.instance.players[(indexPath as NSIndexPath).row]
            confirmDelete(playerToDelete)
        }
    }

    func handleDeletePlayer(_ alertAction: UIAlertAction!) -> Void {
        if let indexPath = deletePlayerIndexPath {
            tabletView.beginUpdates()

            let playerToDelete = DAO.instance.players[(indexPath as NSIndexPath).row]

            DAO.instance.delPlayer(playerToDelete)

            // Note that indexPath is wrapped in an array:  [indexPath]
            tabletView.deleteRows(at: [indexPath], with: .automatic)

            deletePlayerIndexPath = nil

            tabletView.endUpdates()
        }
    }

    func tableView(_ tableView: UITableView, canMoveRowAt indexPath: IndexPath) -> Bool {
        return true
    }

    override func setEditing(_ editing: Bool, animated: Bool) {
        super.setEditing(editing, animated: animated)
        tabletView.setEditing(editing, animated: true)
    }

    func tableView(_ tableView: UITableView, moveRowAt fromIndexPath: IndexPath, to toIndexPath: IndexPath) {
        let playerToMove = DAO.instance.players[(fromIndexPath as NSIndexPath).row]
        DAO.instance.players.remove(at: (fromIndexPath as NSIndexPath).row)
        DAO.instance.players.insert(playerToMove, at: (toIndexPath as NSIndexPath).row)
    }

    func confirmDelete(_ player: Player) {

        let deletePlayer = NSLocalizedString("delete player", comment: "Delete Player")
        let deletePlayerMessage = String.localizedStringWithFormat(NSLocalizedString("delete player message", comment: "Delete Player Message"), player.name)

        let delete = NSLocalizedString("delete", comment: "Delete")
        let cancel = NSLocalizedString("cancel", comment: "Cancel")

        let alert = UIAlertController(title: deletePlayer, message: deletePlayerMessage, preferredStyle: .actionSheet)

        let DeleteAction = UIAlertAction(title: delete, style: .destructive, handler: handleDeletePlayer)
        let CancelAction = UIAlertAction(title: cancel, style: .cancel, handler: nil)

        alert.addAction(DeleteAction)
        alert.addAction(CancelAction)

        self.present(alert, animated: true, completion: nil)
    }

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Force recalculate play will play
        DAO.instance.invalidate()
    }

    func title(forEmptyDataSet scrollView: UIScrollView) -> NSAttributedString? {
        let str = NSLocalizedString("no players", comment: "No players")
        let attrs = [NSFontAttributeName: UIFont.preferredFont(forTextStyle: UIFontTextStyle.headline)]
        return NSAttributedString(string: str, attributes: attrs)
    }

    func description(forEmptyDataSet scrollView: UIScrollView) -> NSAttributedString? {
        let str = NSLocalizedString("add some players", comment: "Add some players")
        let attrs = [NSFontAttributeName: UIFont.preferredFont(forTextStyle: UIFontTextStyle.body)]
        return NSAttributedString(string: str, attributes: attrs)
    }

    func image(forEmptyDataSet scrollView: UIScrollView) -> UIImage? {
        return UIImage(named: "AppIcon60x60")
    }

    func tableView(_ tableView: UITableView, shouldHighlightRowAt indexPath: IndexPath) -> Bool {
        return false
    }


}
