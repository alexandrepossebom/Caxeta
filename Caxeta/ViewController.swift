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
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        DAO.players.append(Player(name: "jaça"))
        DAO.players.append(Player(name: "xande"))
        DAO.players.append(Player(name: "marcinha"))
    }
    
    @IBAction func newGame(sender: UIButton) {
        DAO.newGame()
        self.tabletView.reloadData()
    }
    
    @IBAction func addPlayer(sender: UIButton) {
        
        let alert = UIAlertController(title: "New user", message: "Input username:", preferredStyle: .Alert)
        
        alert.addTextFieldWithConfigurationHandler { (textField) -> Void in
            textField.text = "Name"
        }
        
        alert.addAction(UIAlertAction(title: "OK", style: .Default, handler: {
            (action) -> Void in
            let textField = alert.textFields![0] as UITextField
            let name = textField.text!
            
            if(!DAO.containsUser(name)){
                DAO.players.append(Player(name: name))
            }
            
            self.tabletView.reloadData()
            
        }))
        
        self.presentViewController(alert, animated: true, completion: nil)
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("CellPlayer", forIndexPath: indexPath) as! PlayerTableViewCell
        
        cell.player = DAO.getPlayersWithPoints()[indexPath.row]
        
        cell.labelNome.text = cell.player!.name
        cell.labelPoints.text = "\(cell.player!.points)"
        
        cell.buttonPlayOrRun.selectedSegmentIndex = cell.player!.play ? 0 : 1
        cell.buttonPlayOrRun.setEnabled(cell.player!.points == 1 ? false : true, forSegmentAtIndex: 1)
        
        return cell
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return DAO.getPlayersWithPoints().count
    }
    
    override func viewDidAppear(animated: Bool) {
        self.tabletView.reloadData()
    }
    
}

