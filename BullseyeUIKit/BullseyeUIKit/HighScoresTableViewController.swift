//
//  HighScoresTableViewController.swift
//  BullseyeUIKit
//
//  Created by Admin on 24.09.2020.
//  Copyright © 2020 Alec. All rights reserved.
//

import UIKit

class HighScoresTableViewController: UITableViewController {
    var items = [HighScoreItem]()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        items = PersistencyHelper.loadHighScores()
        
        if items.isEmpty {
            resetHighScores()
        }
    }
    
    @IBAction func resetHighScores() {        
        PersistencyHelper.saveHighScores(items)
        tableView.reloadData()
    }
    
    // MARK: - Navigation
    
    // UIKit invokes prepare(for:sender:) right before it performs a segue from one screen to another.
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        let controller = segue.destination as! EditHighScoreTableViewController
        controller.delegate = self
        
        // sender contains a reference to the control that triggered the segue
        if let indexPath = tableView.indexPath(for: sender as! UITableViewCell) {
            controller.highScoreItem = items[indexPath.row]
        }
    }

    // MARK: - Table View Data Source
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return items.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "HighScoreItem", for: indexPath)
        
        let item = items[indexPath.row]
        
        let nameLabel = cell.viewWithTag(1000) as! UILabel
        let scoreLabel = cell.viewWithTag(2000) as! UILabel
        
        nameLabel.text = item.name
        scoreLabel.text = String(item.score)
        
        return cell
    }
    
    // MARK: - Table View Delegate
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
    }
    
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        items.remove(at: indexPath.row)
    
        let indexPaths = [indexPath]
        tableView.deleteRows(at: indexPaths, with: .automatic)
        
        PersistencyHelper.saveHighScores(items)
    }
}

// MARK: - Edit High Score Table ViewController Delegates

extension HighScoresTableViewController: EditHighScoreTableViewControllerDelegate {
    func editHighScoreTableViewControllerDidCancel(_ controller: EditHighScoreTableViewController) {
        navigationController?.popViewController(animated:true)
    }
    
    func editHighScoreTableViewController(_ controller: EditHighScoreTableViewController, didFinishEditing item: HighScoreItem) {
        if let index = items.firstIndex(of: item) {
            let indexPath = IndexPath(row: index, section: 0)
            let indexPaths = [indexPath]
            
            tableView.reloadRows(at: indexPaths, with: .automatic)
        }
        
        PersistencyHelper.saveHighScores(items)
        
        navigationController?.popViewController(animated: true)
    }
}
