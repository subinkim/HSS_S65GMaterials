//
//  SecondViewController.swift
//  FinalProject
//
//  Created by Van Simmons on 6/5/17.
//  Copyright © 2017 Harvard University. All rights reserved.
//

import UIKit

class StatisticsViewController: UIViewController {

    @IBOutlet weak var aliveTextField: UITextField!
    @IBOutlet weak var bornTextField: UITextField!
    @IBOutlet weak var diedTextField: UITextField!
    @IBOutlet weak var emptyTextField: UITextField!
    
    var aliveCount: Int = 0
    var bornCount: Int = 0
    var diedCount: Int = 0
    var emptyCount: Int = 0
    
    override func viewDidLoad() {
        super.viewDidLoad()
        nc.addObserver(self, selector: #selector(engine(notified:)), name: EngineNotificationName, object: nil)
        nc.addObserver(self, selector: #selector(engineHas(updated:)), name: EngineUpdatedNotification, object: nil)
    }
    
    @objc func engine(notified: Notification) {
        (0 ... StandardEngine.sharedInstance.size).forEach{ row in
            (0 ... StandardEngine.sharedInstance.size).forEach { col in
                switch (StandardEngine.sharedInstance.grid[row, col]){
                case .alive: aliveCount = aliveCount + 1
                case .born: bornCount = bornCount + 1
                case .died: diedCount = diedCount + 1
                case .empty: emptyCount = emptyCount + 1
                }
            }
        }
        aliveTextField.text = "\(aliveCount)"
        bornTextField.text = "\(bornCount)"
        diedTextField.text = "\(diedCount)"
        emptyTextField.text = "\(emptyCount)"
        
    }
    
    @objc func engineHas(updated: Notification){
        aliveTextField.text = "0"
        bornTextField.text = "0"
        diedTextField.text = "0"
        emptyTextField.text = "0"
        aliveCount = 0
        bornCount = 0
        diedCount = 0
        emptyCount = 0
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func reset(_ sender: UIButton) {
        aliveTextField.text = "0"
        bornTextField.text = "0"
        diedTextField.text = "0"
        emptyTextField.text = "0"
        aliveCount = 0
        bornCount = 0
        diedCount = 0
        emptyCount = 0
        
    }
    
}

