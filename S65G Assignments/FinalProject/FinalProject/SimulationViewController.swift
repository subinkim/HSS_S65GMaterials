//
//  FirstViewController.swift
//  FinalProject
//
//  Created by Van Simmons on 6/5/17.
//  Copyright © 2017 Harvard University. All rights reserved.
//

import UIKit

class SimulationViewController: UIViewController, EngineDelegate, GridViewDataSource {
    
    var size = StandardEngine.sharedInstance.size
    
    @IBOutlet weak var gridView: GridView!
    @IBOutlet weak var ConfigurationTextField: UITextField!
    
    subscript(pos: GridPosition) -> CellState {
        get {
            return StandardEngine.sharedInstance.grid[pos.row, pos.col]
        }
        set { StandardEngine.sharedInstance.grid[pos.row, pos.col] = newValue }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        gridView.dataSource = self
        StandardEngine.sharedInstance.delegate = self
        
        nc.addObserver(self, selector: #selector(engine(notification:)), name: EngineNotificationName, object: nil)
        nc.addObserver(self, selector: #selector(configuration(changed:)), name: ConfigurationNotificationName, object: nil)
        gridView.setNeedsDisplay()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        gridView.dataSource?.size = StandardEngine.sharedInstance.size
        nc.post(name: EngineNotificationName, object: nil, userInfo: nil)
        gridView.setNeedsDisplay()
    }
    
    func engineDidUpdate(engine: EngineProtocol) {
        self.gridView.setNeedsDisplay()
    }
    
    @objc func engine(notification: Notification){
        self.gridView.setNeedsDisplay()
    }
    
    @objc func configuration(changed: Notification) {
        let title = changed.userInfo?["title"] as? String
        let contents = changed.userInfo?["contents"] as? [[Int]]
        
        contents?.forEach{
            let position = GridPosition(row: $0[0], col: $0[1])
            StandardEngine.sharedInstance.grid[position.row, position.col] = .alive
        }
        
        self.gridView.setNeedsDisplay()
        
        ConfigurationTextField.text = title
        
    }
    
    @IBAction func step(_ sender: UIButton) {
        StandardEngine.sharedInstance.grid = StandardEngine.sharedInstance.grid.next()
        nc.post(name: EngineNotificationName, object: nil, userInfo: nil)
        gridView.setNeedsDisplay()
    }
    
    @IBAction func reset(_ sender: UIButton) {
        (0 ... gridView.dataSource!.size).forEach{ row in
            (0 ... gridView.dataSource!.size).forEach { col in
                StandardEngine.sharedInstance.grid[row, col] = .empty
            }
        }
        ConfigurationTextField.text = ""
        self.gridView.setNeedsDisplay()
    }
    
    func textFieldShouldEndEditing(_ textField: UITextField) -> Bool {
        return true
    }
    
    @IBAction func didEndOnExit(_ textField: UITextField) {
        guard let text = textField.text else { return }
        print(text)
        textField.resignFirstResponder()
    }
    
    @IBAction func save(_ sender: UIButton) {
        guard let text = ConfigurationTextField.text else { return }
        var config = [[Int]]()
        (0 ... gridView.dataSource!.size).forEach{ row in
            (0 ... gridView.dataSource!.size).forEach { col in
                let pos = [row, col]
                if StandardEngine.sharedInstance.grid[row, col] == .alive{
                    config.append(pos)
                }
            }
        }
        let size = gridView.dataSource!.size
        let info = ["title": text, "contents": config, "size": size] as [String : Any]
        nc.post(name: NewConfigNotification, object: nil, userInfo: info)
    }
    
}

