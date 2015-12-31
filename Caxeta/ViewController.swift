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

    }
    
    
    @IBAction func startRound(sender: UIButton) {
        
        
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

    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("CellPlayer", forIndexPath: indexPath) as! PlayerTableViewCell
                
        cell.labelNome.text = DAO.players[indexPath.row].name
        
        cell.player = DAO.players[indexPath.row]
        
        return cell
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return DAO.players.count
    }

}

