//
//  ConfigurationTableViewController.swift
//  FinalProject
//
//  Created by 김수빈 on 03/08/2018.
//  Copyright © 2018 Harvard University. All rights reserved.
//

import UIKit

class ConfigurationTableViewController: UITableViewController {

    var fetcher = Fetcher()
    var configurations = [Configuration]()
    var index: Int = 0
    var indexPath: IndexPath?
  
    override func viewDidLoad() {
        super.viewDidLoad()
        self.tableView.reloadData()
        
        guard let url = URL(string: ConfigurationURL) else { return }
        fetcher.fetch(url: url) { (response) in
            let op = BlockOperation {
                switch response {
                case .success(let data):
                    do {
                        self.configurations = try JSONDecoder().decode([Configuration].self, from: data)
                        self.tableView.reloadData()
                    } catch {
                        print(error.localizedDescription)
                    }
                case .failure(let msg):
                    print("\(msg)")
                }
            }
            OperationQueue.main.addOperation(op)
        }
        
        nc.addObserver(self, selector: #selector(engine(notified:)), name: NewConfigNotification, object: nil)
//
//        nc.addObserver(self, selector: #selector(configuration(changed:)), name: ConfigurationNotificationName, object: nil)
    }
    
    @objc func engine(notified: Notification) {
        let title = notified.userInfo?["title"] as? String
        var contents = notified.userInfo?["contents"]
        contents = contents.map{ $0 }
        let newConfig = Configuration(title: title, contents: contents as? [[Int]])
        configurations.append(newConfig)
        self.tableView.reloadData()
    }
    
//    @objc func configuration(changed: Notification) {
//        let title = changed.userInfo?["title"] as? String
//        let contents = changed.userInfo?["contents"] as? [[Int]]
//        configurations[index] = Configuration(title: title, contents: contents)
//        self.tableView.reloadData()
//    }

    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return configurations.count
    }

    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "Configuration", for: indexPath)
        cell.textLabel?.text = configurations[indexPath.row].title ?? "None"
        
        return cell
    }
    

    /*
    // Override to support conditional editing of the table view.
    override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the specified item to be editable.
        return true
    }
    */
    
    override func tableView(_ tableView: UITableView, editActionsForRowAt indexPath: IndexPath) -> [UITableViewRowAction]? {
        let delete = UITableViewRowAction(style: .destructive, title: "Delete") { (action, indexPath) in
            self.configurations.remove(at: indexPath.row)
            tableView.reloadData()
        }
        
        let edit = UITableViewRowAction(style: .normal, title: "Edit") { (action, indexPath) in
            self.indexPath = indexPath
            self.tableView.selectRow(at: indexPath, animated: false, scrollPosition: .none)
            self.performSegue(withIdentifier: "Edit", sender: self)
        }

        edit.backgroundColor = UIColor.green

        return [delete, edit]
    }

    // Override to support editing the table view.
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            var newValue = configurations
            newValue.remove(at: indexPath.row)
            configurations = newValue
            tableView.deleteRows(at: [indexPath], with: .automatic)
            tableView.reloadData()
        }
    }
    

    /*
    // Override to support rearranging the table view.
    override func tableView(_ tableView: UITableView, moveRowAt fromIndexPath: IndexPath, to: IndexPath) {

    }
    */

    /*
    // Override to support conditional rearranging of the table view.
    override func tableView(_ tableView: UITableView, canMoveRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the item to be re-orderable.
        return true
    }
    */

    
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        guard let destination = segue.destination as? GridEditorViewController else { return }
        guard let indexPath = self.indexPath ?? self.tableView.indexPathForSelectedRow else { return }
        destination.configuration = configurations[indexPath.row]
        self.indexPath = nil

        destination.updateClosure = { (configuration) in
            self.configurations[indexPath.row] = configuration
            self.tableView.reloadData()
        }
    }
}
