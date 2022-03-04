//
//  AllListsViewController.swift
//  CheckList
//
//  Created by Ahmed Nagy on 21/02/2022.
//

import UIKit

class AllListsViewController: UITableViewController, ListDetailViewControllerDelegate {

    
    
    // data source
    var lists = [Checklist]()

    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Add placeholder data
        var list = Checklist(name: "Birthdays")
        lists.append(list)
        
        list = Checklist(name: "Groceries")
        lists.append(list)
        
        list = Checklist(name: "Cool Apps")
        lists.append(list)
        
        list = Checklist(name: "To Do")
        lists.append(list)

        tableView.register(UITableViewCell.self, forCellReuseIdentifier: Constants.AllListViewControllerCellIdentifier)
        
        // Enable large titles
        navigationController?.navigationBar.prefersLargeTitles = true
        
        for list in lists {
            let item = ChecklistItem()
            item.text = "Item for \(list.name)"
            list.items.append(item)
        }
        
    }

    // MARK: - Table view data source

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return lists.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: Constants.AllListViewControllerCellIdentifier, for: indexPath)
        let checkList = lists[indexPath.row]
        cell.textLabel?.text = checkList.name
        cell.accessoryType = .detailDisclosureButton
        cell.tintColor = UIColor(red: 59/255, green: 190/255, blue: 47/255, alpha: 1)
        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let checkList = lists[indexPath.row]
        performSegue(withIdentifier: Constants.ShowChecklistSegueIdentifier, sender: checkList)
    }
    
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        lists.remove(at: indexPath.row)
        tableView.deleteRows(at: [indexPath], with: .fade)
    }
    
    // MARK: - Table view delegate methods
    override func tableView(_ tableView: UITableView, accessoryButtonTappedForRowWith indexPath: IndexPath) {
        let controller = storyboard?.instantiateViewController(withIdentifier: Constants.listDetailViewControllerIdentifier) as! listDetailViewController
        controller.delegate = self
        controller.checklistItemToEdit = lists[indexPath.row]
        navigationController?.pushViewController(controller, animated: true)
    }
    
    // MARK: - List Detail View Controller Delegates
    func listDetailViewControllerDidCancel(_ controller: listDetailViewController) {
        navigationController?.popViewController(animated: true)
    }
    
    func listDetailViewController(_ controller: listDetailViewController, didFinishAdding checkList: Checklist) {
        let newRowIndex = lists.count
        let indexPath = IndexPath(row: newRowIndex, section: 0)
        let indexPaths = [indexPath]
        
        lists.append(checkList)
        tableView.insertRows(at: indexPaths, with: .fade)
        navigationController?.popViewController(animated: true)
    }
    
    func listDetailViewController(_ controller: listDetailViewController, didFinishEditing checkList: Checklist) {
        if let index = lists.firstIndex(of: checkList) {
            let indexPath = IndexPath(row: index, section: 0)
            if let cell = tableView.cellForRow(at: indexPath) {
                cell.textLabel?.text = checkList.name
            }
        }
        navigationController?.popViewController(animated: true)
    }
    
    // MARK: - Navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        print("Prepare for segue")
        if segue.identifier == Constants.ShowChecklistSegueIdentifier {
            let controller = segue.destination as! ChecklistViewController
            controller.checkList = sender as? Checklist
        } else if segue.identifier == Constants.addCheckListSegue {
            let controller = segue.destination as! listDetailViewController
            controller.delegate = self
        }
    }
    
}
