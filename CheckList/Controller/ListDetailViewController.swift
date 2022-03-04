//
//  ListDetailViewController.swift
//  CheckList
//
//  Created by Ahmed Nagy on 23/02/2022.
//

import Foundation
import UIKit

protocol ListDetailViewControllerDelegate: AnyObject {
    func listDetailViewControllerDidCancel(_ controller: listDetailViewController)
    func listDetailViewController(_ controller: listDetailViewController, didFinishAdding checkList: Checklist)
    func listDetailViewController(_ controller: listDetailViewController, didFinishEditing checkList: Checklist)
    
}

class listDetailViewController: UITableViewController, UITextFieldDelegate {
    @IBOutlet var textField: UITextField!
    @IBOutlet var doneBarButton: UIBarButtonItem!
    
    weak var delegate: ListDetailViewControllerDelegate?
    var checklistItemToEdit: Checklist?
    
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        textField.becomeFirstResponder()
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        
        if let checklistItemToEdit = checklistItemToEdit {
            title = "Edit Checklist"
            textField.text = checklistItemToEdit.name
            doneBarButton.isEnabled = true
        }
    }
    
    // MARK: - Text Field Delegates
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        let oldText = textField.text!
        let stringRange = Range(range, in: oldText)
        let newText = oldText.replacingCharacters(in: stringRange!, with: string)
        doneBarButton.isEnabled = !newText.isEmpty
        return true
    }
    
    func textFieldShouldClear(_ textField: UITextField) -> Bool {
        doneBarButton.isEnabled = false
        return true
    }
    
    
    // MARK: - Table View Delegates
    override func tableView(_ tableView: UITableView, willSelectRowAt indexPath: IndexPath) -> IndexPath? {
        return nil
    }
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        60
    }
    
    // MARK: - Actions
    @IBAction func cancel() {
        delegate?.listDetailViewControllerDidCancel(self)
    }
    
    @IBAction func done() {
        if let checklistItemToEdit = checklistItemToEdit {
            checklistItemToEdit.name = textField.text!
            delegate?.listDetailViewController(self, didFinishEditing: checklistItemToEdit)
        } else {
            let checkList = Checklist(name: textField.text!)
            delegate?.listDetailViewController(self, didFinishAdding: checkList)
        }
    }
}
