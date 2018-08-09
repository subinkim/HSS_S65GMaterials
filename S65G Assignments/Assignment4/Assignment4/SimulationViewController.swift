//
//  SimulationViewController.swift
//  Assignment4
//
//  Created by Van Simmons on 6/5/17.
//  Copyright © 2017 Harvard University. All rights reserved.
//

import UIKit


class SimulationViewController: UIViewController, EngineDelegate, GridViewDataSource {
    
    subscript(pos: Position) -> CellState {
        get { return StandardEngine.sharedInstance.grid[pos] }
        set { return }
    }
    var row: Int = 10
    var col: Int = 10
    
    
    @IBOutlet weak var gridView: GridView!
    @IBOutlet weak var step: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        gridView?.dataSource = self
        StandardEngine.sharedInstance.delegate = self
        let nc = NotificationCenter.default
        let name = Notification.Name(rawValue: "EngineUpdate")
        nc.addObserver(self, selector: #selector(engine(notified:)), name: name, object: nil)
    }
    
    @objc func engine(notified: Notification){
        self.gridView.setNeedsDisplay()
    }
    
    //MARK: Engine Delegate
    func engineDidUpdate(engine: EngineProtocol) {
        self.gridView.setNeedsDisplay()
    }
    
    @IBAction func step(_ sender: Any) {
        StandardEngine.sharedInstance.grid = StandardEngine.sharedInstance.grid.next()
        gridView.setNeedsDisplay()
    }
}

