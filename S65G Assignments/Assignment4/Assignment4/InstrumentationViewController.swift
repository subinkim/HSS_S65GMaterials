//
//  InstrumentationViewController.swift
//  Assignment4
//
//  Created by Van Simmons on 6/5/17.
//  Copyright © 2017 Harvard University. All rights reserved.
//

import UIKit

class InstrumentationViewController: UIViewController, UITextFieldDelegate {
    
    static var sharedInstance: EngineProtocol = StandardEngine(row: 10, col: 10)
    
    @IBOutlet weak var SizeTextField: UITextField!
    @IBOutlet weak var SizeStepper: UIStepper!
    @IBOutlet weak var PeriodSlider: UISlider!
    @IBOutlet weak var RefreshSwitch: UISwitch!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
    }
    
    @IBAction func changeSize (_ sender: UIStepper){
        SizeTextField.text = Int(sender.value).description
    }
    
    //MARK: UITextFieldDelegate
    func textFieldShouldEndEditing(_ textField: UITextField) -> Bool {
        return true
    }
    
    func textFieldDidBeginEditing(_ textField: UITextField) {
        print("Began editing.")
    }
    
    @IBAction func didEndOnExit(_ textField: UITextField) {
        guard let text = textField.text else { return }
        guard let size = Int(text) else { return }
        guard let interval = Double(text) else { return }
        guard (size >= Int(SizeStepper.minimumValue) && size <= Int(SizeStepper.maximumValue)) else { return }
        StandardEngine.sharedInstance.row = size
        StandardEngine.sharedInstance.col = size
        if StandardEngine.sharedInstance.refreshRate != interval {
            StandardEngine.sharedInstance.refreshRate = interval
        }
        textField.resignFirstResponder()
    }
    
    @IBAction func switchOff (_ sender: UISwitch){
        if (!sender.isOn) {
            StandardEngine.sharedInstance.refreshTimer?.invalidate()
            StandardEngine.sharedInstance.refreshTimer = nil
        }
    }
    
    @IBAction func changeInterval (_ sender: UISlider){
        let interval = Double(Int(sender.value))
        if (StandardEngine.sharedInstance.refreshRate != interval){
            StandardEngine.sharedInstance.refreshRate = interval
        }
    }
}

