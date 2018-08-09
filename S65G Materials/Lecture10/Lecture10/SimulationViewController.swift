//
//  FirstViewController.swift
//  Lecture10
//
//  Created by Van Simmons on 7/30/18.
//  Copyright © 2018 ComputeCycles, LLC. All rights reserved.
//

import UIKit

class SimulationViewController: UIViewController, GridViewDataSource, EngineDelegate {
    
    func engine(didUpdate: Engine) {
    
    }
    
    subscript(pos: GridPosition) -> CellState {
        get { return Engine.sharedInstance.grid[pos.row, pos.col] }
        set { Engine.sharedInstance.grid[pos.row, pos.col] = newValue }
    }
    
    var size: Int = 10
    

    @IBOutlet weak var gridView: GridView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        gridView.dataSource = self
        
        Engine.sharedInstance.delegate = self
        Engine.sharedInstance.updateClosure = { (engine:Engine) -> Void in
            self.gridView.setNeedsDisplay()
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }


}

