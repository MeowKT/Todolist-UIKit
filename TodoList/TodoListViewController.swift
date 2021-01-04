//
//  TodoListViewController.swift
//  TodoList
//
//  Created by Savva on 01.01.2021.
//

import UIKit

class TodoListViewController: UITableViewController {
    
    let dataDownloader = DataDownloader.shared
    
    var data: [Note] = [] {
        didSet {
            dataDownloader.loadData(notes: self.data)
        }
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        DataDownloader.shared.getData { notes in
            self.data = notes
            self.tableView.reloadData()
        }
        self.navigationItem.leftBarButtonItem = self.editButtonItem
    }
    
    @IBAction func unwindSegue(segue: UIStoryboardSegue) {
        guard segue.identifier == "saveSegue" else {
            return
        }
        let addNoteController = segue.source as! AddNoteController
        if let indexPath = tableView.indexPathForSelectedRow {
            data[indexPath.row] = addNoteController.note!
            tableView.reloadData()
        } else {
            let indexPath = IndexPath(row: data.count, section: 0)
            data.append((segue.source as! AddNoteController).note!)
            tableView.insertRows(at: [indexPath], with: .fade)
        }
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        super.prepare(for: segue, sender: sender)
        guard segue.identifier == "EditSegue" else {
            return
        }
        let navigationVC = segue.destination as! UINavigationController
        let addNoteController = navigationVC.topViewController as! AddNoteController
        addNoteController.note = data[tableView.indexPathForSelectedRow!.row]
    }

    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return data.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "TodoCell", for: indexPath) as! TodoListCell
        cell.setData(note: data[indexPath.row])
        return cell
    }
    
    override func tableView(_ tableView: UITableView, editingStyleForRowAt indexPath: IndexPath) -> UITableViewCell.EditingStyle {
        return .delete
    }
    
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            data.remove(at: indexPath.row)
            tableView.deleteRows(at: [indexPath], with: .fade)
        }
    }
    
    override func tableView(_ tableView: UITableView, leadingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
        UISwipeActionsConfiguration(actions: [finishNote(at: indexPath)])
    }
    
    private func finishNote(at indexPath: IndexPath) -> UIContextualAction {
        let action = UIContextualAction(style: .destructive, title: "Done") { (action, view, completion) in
            self.data.remove(at: indexPath.row)
            self.tableView.deleteRows(at: [indexPath], with: .fade)
            completion(true)
        }
        action.backgroundColor = .green
        action.image = UIImage(systemName: "checkmark.seal")
        return action
    }
    
}
