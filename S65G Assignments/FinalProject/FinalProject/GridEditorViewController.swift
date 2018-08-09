//
//  GridEditorViewController.swift
//  FinalProject
//
//  Created by 김수빈 on 03/08/2018.
//  Copyright © 2018 Harvard University. All rights reserved.
//

import UIKit

typealias UpdateClosure = (Configuration) -> Void

var localInstance = StandardEngine(10)

class GridEditorViewController: UIViewController, GridViewDataSource {
    
    subscript(pos: GridPosition) -> CellState {
        get {
            return localInstance.grid[pos.row, pos.col]
        }
        set {
            localInstance.grid[pos.row, pos.col] = newValue
        }
    }
    
    var size: Int {
        get { return localInstance.size }
        set { localInstance.size = newValue }
    }
    
    var configuration: Configuration!
    var updateClosure: UpdateClosure?
    @IBOutlet weak var configurationName: UILabel!
    @IBOutlet weak var gridView: GridView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        gridView.dataSource = self

        configurationName.text = configuration.title
        
        if configuration.contents == [[]]{
            localInstance.size = 10
            gridView.dataSource?.size = 10
            (0 ... 10).forEach{ row in
                (0 ... 10).forEach { col in
                    let pos = GridPosition(row: row, col: col)
                    localInstance.grid[pos.row, pos.col] = .empty
                }
            }
        }
        else {
            let row = configuration.contents?.reduce(0) { return $1[0] > $0 ? $1[0] : $0 }
            let col = configuration.contents?.reduce(0) { return $1[1] > $0 ? $1[1] : $0 }
            
            localInstance.size = 2 * max(row!, col!)
            
            (0 ... row!).forEach{ row in
                (0 ... col!).forEach { col in
                    let pos = GridPosition(row: row, col: col)
                    localInstance.grid[pos.row, pos.col] = .empty
                }
            }
            
            configuration.contents?.forEach{
                let position = GridPosition(row: $0[0], col: $0[1])
                localInstance.grid[position.row, position.col] = .alive
            }
        }
        
        nc.addObserver(self, selector: #selector(engine(cancelled:)), name: NSNotification.Name(rawValue: "cancel"), object: nil)
        
        gridView.setNeedsDisplay()
    }
    
    @objc func engine(cancelled: Notification) {
        (0 ... gridView.dataSource!.size).forEach{ row in
            (0 ... gridView.dataSource!.size).forEach { col in
                let pos = GridPosition(row: row, col: col)
                localInstance.grid[pos.row, pos.col] = .empty
            }
        }
        configuration.contents?.forEach{
            let position = GridPosition(row: $0[0], col: $0[1])
            localInstance.grid[position.row, position.col] = .alive
        }
    }
    
    @IBAction func publish(_ sender: UIButton) {
        var contentsArray = [[Int]]()
        (0 ... gridView.dataSource!.size).forEach{ row in
            (0 ... gridView.dataSource!.size).forEach { col in
                let pos = [row, col]
                switch(localInstance.grid[row, col]){
                case .alive: contentsArray.append(pos)
                case .born: contentsArray.append(pos)
                default: return
                }
            }
        }
        
        StandardEngine.sharedInstance.grid = localInstance.grid
        StandardEngine.sharedInstance.size = localInstance.size

        let size = ["size": StandardEngine.sharedInstance.size]
        nc.post(name: ChangeSize, object: nil, userInfo: size)
        
        let info = ["title": configuration.title!, "contents": contentsArray] as [String : Any]
        nc.post(name: ConfigurationNotificationName, object: nil, userInfo: info)
        configuration.contents = contentsArray
        updateClosure?(configuration)
        
        self.navigationController?.popViewController(animated: true)
        
    }
    
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
