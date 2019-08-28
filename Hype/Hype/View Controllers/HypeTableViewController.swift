//
//  HypeTableViewController.swift
//  Hype
//
//  Created by Apps on 8/26/19.
//  Copyright © 2019 Apps. All rights reserved.
//

import UIKit

class HypeTableViewController: UITableViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        loadData()
        configureRefreshControl()
    }
    
    func configureRefreshControl () {
        // Add the refresh control to your UIScrollView object.
        tableView.refreshControl = UIRefreshControl()
        tableView.refreshControl?.addTarget(self, action:
            #selector(handleRefreshControl),
                                                  for: .valueChanged)
    }

    @objc func handleRefreshControl() {
        // Update your content…

        // Dismiss the refresh control.
        self.loadData()
        DispatchQueue.main.async {
            self.tableView.refreshControl?.endRefreshing()
        }
    }
    
    func loadData() {
        HypeController.sharedInstance.fetchHypes { (success) in
            if success {
                DispatchQueue.main.async {
                    self.tableView.reloadData()
                }
            }
        }
    }
    
    func presentAddHypeAlert(updatedHype: Hype?) {
        let alertController = UIAlertController(title: "Get Hype", message: "What is hype may never die!", preferredStyle: .alert)
        
        alertController.addTextField { (textField) in
            textField.placeholder = "What's hyping today Bruh?"
        }
        
        // ADD ACTION
        let addHypeAction = UIAlertAction(title: "Add Hype", style: .default) { (_) in
            guard let hypeText = alertController.textFields?.first?.text else { return }
            if hypeText != "" && updatedHype == nil {
                HypeController.sharedInstance.saveHype(text: hypeText, completion: { (success) in
                    if success {
                        DispatchQueue.main.async {
                            self.tableView.reloadData()
                        }
                    }
                })
            } else {
                guard let hype = updatedHype else { return }
                HypeController.sharedInstance.updateHype(hype: hype, newText: hypeText, completion: { (success) in
                    if success {
                        DispatchQueue.main.async {
                            self.tableView.reloadData()
                        }
                    }
                })
            }
        }
        // CANCEL ACTION
        let cancelAction = UIAlertAction(title: "Cancel", style: .destructive)
        
        alertController.addAction(addHypeAction)
        alertController.addAction(cancelAction)
        present(alertController, animated: true)
        
    }

    @IBAction func addButtonTapped(_ sender: Any) {
        presentAddHypeAlert(updatedHype: nil)
    }
    
    // MARK: - Table view data source
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return HypeController.sharedInstance.hypes.count
    }


    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "hypeCell", for: indexPath)
        let hype = HypeController.sharedInstance.hypes[indexPath.row]
        
//        let dateForm = DateFormatter()
//        dateForm.dateStyle = .medium
//        dateForm.timeStyle = .medium
//        let date = dateForm.string(from: hype.timestamp)
        let dateSTR = DateHelper.shared.mediumStringForDateAndTime(date: hype.timestamp)
        
        cell.textLabel?.text = hype.hypeText
        cell.detailTextLabel?.text = dateSTR
        
        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let hype = HypeController.sharedInstance.hypes[indexPath.row]
        presentAddHypeAlert(updatedHype: hype)
    }
    
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            let hype = HypeController.sharedInstance.hypes[indexPath.row]
            HypeController.sharedInstance.remove(hype: hype) { (success) in
                if success {
                    DispatchQueue.main.async {
                        self.tableView.deleteRows(at: [indexPath], with: .automatic)
                    }
                }
            }
        }
    }
}
