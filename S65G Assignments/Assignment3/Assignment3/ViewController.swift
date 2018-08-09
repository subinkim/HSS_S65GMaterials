//
//  ViewController.swift
//  Assignment3
//
//  Created by Van Simmons on 6/5/17.
//  Copyright © 2017 Harvard University. All rights reserved.
//

import UIKit

class ViewController: UIViewController {
    

    @IBOutlet weak internal var gridView: GridView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        gridView.grid = Grid(gridView.size, gridView.size, cellInitializer: defaultInitializer)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func step(_ sender: Any) {
        gridView.grid = gridView.grid.next()
    }

}

