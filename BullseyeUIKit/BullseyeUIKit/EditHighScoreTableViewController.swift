//
//  EditHighScoreTableViewController.swift
//  BullseyeUIKit
//
//  Created by Admin on 26.09.2020.
//  Copyright © 2020 Alec. All rights reserved.
//

import UIKit

protocol EditHighScoreTableViewControllerDelegate: class {
    func editHighScoreTableViewControllerDidCancel(_ controller: EditHighScoreTableViewController)
    func editHighScoreTableViewController(_ controller: EditHighScoreTableViewController, didFinishEditing item: HighScoreItem)
}

class EditHighScoreTableViewController: UITableViewController {
    weak var delegate: EditHighScoreTableViewControllerDelegate?
    var highScoreItem: HighScoreItem!
    
    @IBOutlet private weak var doneBarButton: UIBarButtonItem!
    @IBOutlet private weak var textField: UITextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        textField.text = highScoreItem.name
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        textField.becomeFirstResponder()
    }
    
    @IBAction private func cancel() {
        if let delegate = delegate {
            delegate.editHighScoreTableViewControllerDidCancel(self)
        }
    }
    
    @IBAction private func done() {
        highScoreItem.name = textField.text!
        
        if let delegate = delegate {
            delegate.editHighScoreTableViewController(self, didFinishEditing: highScoreItem)
        }
    }
    
    // MARK: - Table View Delegates
    
    override func tableView(_ tableView: UITableView, willSelectRowAt indexPath: IndexPath) -> IndexPath? {
        return nil
    }
}

// MARK: - Text Field Delegates

extension EditHighScoreTableViewController: UITextFieldDelegate {
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        let oldText = textField.text!
        let stringRange = Range(range, in: oldText)!
        let newText = oldText.replacingCharacters(in: stringRange, with: string)
        
        doneBarButton.isEnabled = !newText.isEmpty
        
        return true
    }
}
