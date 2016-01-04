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
    }
    
    @IBAction func newGame(sender: UIButton) {
        DAO.instance.newGame()
        self.tabletView.reloadData()
    }
    
    @IBAction func addPlayer(sender: UIButton) {
        
        let alert = UIAlertController(title: "New user", message: "Input username:", preferredStyle: .Alert)
        
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
                self.tabletView.insertRowsAtIndexPaths([NSIndexPath(forRow: DAO.instance.getPlayersWithPoints().count-1, inSection: 0)], withRowAnimation: .Automatic)
                self.tabletView.endUpdates()
            }
        }))
        
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
        let alert = UIAlertController(title: "Delete Player", message: "Are you sure you want to permanently delete \(player.name)?", preferredStyle: .ActionSheet)
        
        let DeleteAction = UIAlertAction(title: "Delete", style: .Destructive, handler: handleDeletePlayer)
        let CancelAction = UIAlertAction(title: "Cancel", style: .Cancel, handler: nil)
        
        alert.addAction(DeleteAction)
        alert.addAction(CancelAction)
        
        self.presentViewController(alert, animated: true, completion: nil)
    }
    
}

