//
//  EditHighScoreTableViewController.swift
//  BullseyeUIKit
//
//  Created by Admin on 26.09.2020.
//  Copyright © 2020 Alec. All rights reserved.
//

import UIKit

class EditHighScoreTableViewController: UITableViewController {
    @IBOutlet private weak var doneBarButton: UIBarButtonItem!
    @IBOutlet private weak var textField: UITextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        textField.becomeFirstResponder()
    }
    
    @IBAction private func cancel() {
        if let navigationController = navigationController {
            navigationController.popViewController(animated: true)
        }
    }
    
    @IBAction private func done() {
        if let navigationController = navigationController {
            print("Contents of the text field: \(textField.text!)")
            
            navigationController.popViewController(animated: true)
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
