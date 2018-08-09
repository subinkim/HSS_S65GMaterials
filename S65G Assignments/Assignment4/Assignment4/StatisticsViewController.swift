//
//  StatisticsViewController.swift
//  Assignment4
//
//  Created by 김수빈 on 20/07/2018.
//  Copyright © 2018 Harvard University. All rights reserved.
//

import UIKit

class StatisticsViewController: UIViewController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        let nc = NotificationCenter.default
        let name = Notification.Name(rawValue: "EngineUpdate")
        nc.addObserver(self, selector: #selector(cellStateCount(notified:)), name: name, object: nil)
    }
    
    @objc func cellStateCount(notified: Notification){
        
    }
    
    
}
