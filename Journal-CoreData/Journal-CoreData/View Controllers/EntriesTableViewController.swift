//
//  EntriesTableViewController.swift
//  Journal-CoreData
//
//  Created by Jerrick Warren on 11/6/18.
//  Copyright © 2018 Jerrick Warren. All rights reserved.
//

import UIKit
import CoreData

class EntriesTableViewController: UITableViewController, NSFetchedResultsControllerDelegate {
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        tableView.reloadData()
    }
    
    // MARK: - Table view data source
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
//    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
//        return fetchedResultsController.sections?[section].numberOfObjects ?? 0
//    }
//    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        print(entryController.entries)
        return entryController.entries.count
    }
    
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath) as! EntryTableViewCell
        let entry = entryController.entries[indexPath.row]
        cell.entry = entry
        
        cell.titleLabel.text = entry.title
        cell.detailTextLabel?.text = entry.title
        
        return cell
    }
    
    
    /*
     // Override to support conditional editing of the table view.
     override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
     // Return false if you do not want the specified item to be editable.
     return true
     }
     */
    
    

    // Override to support editing the table view.
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            
            let entry = entryController.entries[indexPath.row]
            let moc = CoreDataStack.shared.mainContext
            moc.delete(entry)
            
            do {
                try moc.save()
            }catch {
                moc.reset()
            }
            
            tableView.deleteRows(at: [indexPath], with: .fade)
        }    
    }
    
    
    // MARK: - Navigation
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        let detailVC = segue.destination as! EntryDetailViewController
        detailVC.entryController = entryController
        if segue.identifier == "detailSegue" {
            if let indexPath = tableView.indexPathForSelectedRow {
                detailVC.entry = entryController.entries[indexPath.row]
            }
        }
    }
    
    // Mark: - Properties
    
    let entryController = EntryController()
    
    
    // MARK: - FRC
    
    // here are the objects I want to display
    // observe the managegeObjectContext for changes
    // if object edit, deleted, or moved.
    // can split the data in separate options
    
    lazy var fetchResultsController: NSFetchedResultsController<Entry> = {
        // create a fetch request
        // must provide sortDiscriptors - what order the results should return into
        let fetchRequest: NSFetchRequest<Entry> = Entry.fetchRequest()
        fetchRequest.sortDescriptors = [NSSortDescriptor(key: "name", ascending: true)]
        let moc = CoreDataStack.shared.mainContext
        let frc = NSFetchedResultsController(fetchRequest: fetchRequest,
                                             managedObjectContext: moc,
                                             sectionNameKeyPath: nil,
                                             cacheName: nil)
        frc.delegate = self
        try! frc.performFetch()
        return frc
    }()
    
}

