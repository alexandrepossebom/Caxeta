//
//  ViewController.swift
//  Caxeta
//
//  Created by Alexandre Possebom on 28/12/15.
//  Copyright © 2015 Alexandre Possebom. All rights reserved.
//

import UIKit


class ViewController: UIViewController, UITableViewDataSource, UITableViewDelegate{
    
    
    @IBOutlet weak var tabletView: UITableView!
    
    var deletePlayerIndexPath: NSIndexPath? = nil
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.title = "Caxeta"
        
        //For dont show separator for empty cells
        self.tabletView.tableFooterView = UIView(frame: CGRectZero)
    }
    
    @IBAction func addPlayer(sender: UIButton) {
        
        let newPlayer = NSLocalizedString("new player", comment: "New player")
        let enterPlayerName = NSLocalizedString("input name", comment: "Enter the player name")
        
        let alert = UIAlertController(title: newPlayer, message: enterPlayerName, preferredStyle: .Alert)
        
        alert.addTextFieldWithConfigurationHandler { (textField) -> Void in
            textField.autocapitalizationType = .Words
        }
        
        alert.addAction(UIAlertAction(title: "OK", style: .Default, handler: {
            (action) -> Void in
            let textField = alert.textFields![0] as UITextField
            let name = textField.text!
            
            if(name.characters.count > 0){
                DAO.instance.addPlayer(name)
                
                // Update Table Data
                self.tabletView.beginUpdates()
                let lastRow = DAO.instance.getPlayersWithPoints().count - 1
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
        let cell = tableView.dequeueReusableCellWithIdentifier("CellPlayer", forIndexPath: indexPath) as! PlayerTableViewCell
        
        cell.player = DAO.instance.getPlayersWithPoints()[indexPath.row]
        
        cell.labelNome.text = cell.player!.name
        cell.labelPoints.text = "\(cell.player!.points)"
        
        cell.buttonPlayOrRun.selectedSegmentIndex = cell.player!.play ? 0 : 1
        cell.buttonPlayOrRun.setEnabled(cell.player!.points == 1 ? false : true, forSegmentAtIndex: 1)
        
        return cell
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return DAO.instance.getPlayersWithPoints().count
    }
    
    override func viewDidAppear(animated: Bool) {
        self.tabletView.reloadData()
    }
    
    func tableView(tableView: UITableView, commitEditingStyle editingStyle: UITableViewCellEditingStyle, forRowAtIndexPath indexPath: NSIndexPath) {
        if editingStyle == .Delete {
            deletePlayerIndexPath = indexPath
            let playerToDelete = DAO.instance.getPlayersWithPoints()[indexPath.row]
            confirmDelete(playerToDelete)
        }
    }
    
    func handleDeletePlayer(alertAction: UIAlertAction!) -> Void {
        if let indexPath = deletePlayerIndexPath {
            tabletView.beginUpdates()
            
            let playerToDelete = DAO.instance.getPlayersWithPoints()[indexPath.row]
            
            DAO.instance.delPlayer(playerToDelete)
            
            // Note that indexPath is wrapped in an array:  [indexPath]
            tabletView.deleteRowsAtIndexPaths([indexPath], withRowAnimation: .Automatic)
            
            deletePlayerIndexPath = nil
            
            tabletView.endUpdates()
        }
    }
    
    func confirmDelete(player: Player) {
        
        let deletePlayer = NSLocalizedString("delete player", comment: "Delete Player")
        let deletePlayerMessage = String.localizedStringWithFormat(NSLocalizedString("delete player message",comment: "Delete Player Message"),player.name)
        
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
        //Force recalculate play will play
        DAO.instance.invalidate()
    }
    
}

