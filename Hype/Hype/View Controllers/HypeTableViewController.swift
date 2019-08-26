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
    
    func presentAddHypeAlert() {
        let alertController = UIAlertController(title: "Get Hype", message: "What is hype may never die!", preferredStyle: .alert)
        
        alertController.addTextField { (textField) in
            textField.placeholder = "What's hyping today Bruh?"
        }
        
        // ADD ACTION
        let addHypeAction = UIAlertAction(title: "Add Hype", style: .default) { (_) in
            guard let hypeText = alertController.textFields?.first?.text else { return }
            if hypeText != "" {
                HypeController.sharedInstance.saveHype(text: hypeText, completion: { (success) in
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
            presentAddHypeAlert()
    }
    
    // MARK: - Table view data source
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return HypeController.sharedInstance.hypes.count
    }


    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "hypeCell", for: indexPath)
        let hype = HypeController.sharedInstance.hypes[indexPath.row]
        
        cell.textLabel?.text = hype.hypeText
        cell.detailTextLabel?.text = "\(hype.timestamp)"
        
        return cell
    }
    
}
