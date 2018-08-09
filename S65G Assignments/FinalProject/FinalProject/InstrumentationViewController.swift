//
//  InstrumentationViewController.swift
//  FinalProject
//
//  Created by 김수빈 on 03/08/2018.
//  Copyright © 2018 Harvard University. All rights reserved.
//

import UIKit

let NewConfigNotification = Notification.Name(rawValue: "NewAdded")
let ConfigurationNotificationName = Notification.Name(rawValue: "ConfigurationUpdate")
let ChangeSize = Notification.Name(rawValue: "SizeChanged")
let EngineUpdatedNotification = NSNotification.Name(rawValue: "EngineChanged")
let EngineNotificationName = Notification.Name(rawValue: "EngineUpdate")

let nc = NotificationCenter.default

class InstrumentationViewController: UIViewController, UITextFieldDelegate {
    
    @IBOutlet weak var SizeTextField: UITextField!
    @IBOutlet weak var SizeStepper: UIStepper!
    @IBOutlet weak var RefreshRateSlider: UISlider!
    @IBOutlet weak var RefreshSwitch: UISwitch!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        nc.addObserver(self, selector: #selector(size(changed:)), name: ChangeSize, object: nil)
    }
    
    @objc func size(changed: Notification){
        let size = changed.userInfo?["size"] as? Int
        SizeTextField.text = "\(size!)"
    }
    
    @IBAction func changeSize(_ sender: UIStepper) {
        let size = Int(sender.value)
        SizeTextField.text = size.description
        StandardEngine.sharedInstance.size = size
    }
    
    func textFieldShouldEndEditing(_ textField: UITextField) -> Bool {
        return true
    }

    @IBAction func didEndOnExit(_ textField: UITextField) {
        guard let size = Int(SizeTextField.text!) else { SizeStepper.value = 10.0; return }
        guard size >= Int(SizeStepper.minimumValue) && size <= Int(SizeStepper.maximumValue) else { return }
        SizeStepper.value = Double(size)
        StandardEngine.sharedInstance.size = size
        textField.resignFirstResponder()
    }
    
    
    @IBAction func changeRefreshRate(_ sender: UISlider) {
        let interval = Double(sender.value)
        if StandardEngine.sharedInstance.refreshRate != interval {
            StandardEngine.sharedInstance.refreshRate = interval
        }
    }
    
    @IBAction func switchTimer(_ sender: UISwitch) {
        if sender.isOn == false {
            StandardEngine.sharedInstance.refreshRate = 0.0
            RefreshRateSlider.value = 0.5
            StandardEngine.sharedInstance.refreshTimer?.invalidate()
            StandardEngine.sharedInstance.refreshTimer = nil
        } else {
            StandardEngine.sharedInstance.refreshRate = 0.5
        }
    }
    
    @IBAction func Add(_ sender: UIBarButtonItem) {
        
        let info = ["title":"NewAdded", "contents": [[]]] as [String : Any]
        nc.post(name: NewConfigNotification, object: nil, userInfo: info)
    }
    
    @IBAction func Cancel(_ sender: UIBarButtonItem) {
        nc.post(name: NSNotification.Name(rawValue:"cancel"), object: nil, userInfo: nil)
    }
    
    
    /*
    // MARK: - Navigation
    
    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {

    }
    */
}
