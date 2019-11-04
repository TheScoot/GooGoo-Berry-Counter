//
//  ViewController.swift
//  GooGoo Berry Counter
//
//  Created by Scott Bedard on 10/25/19.
//  Copyright © 2019 Scott Bedard. All rights reserved.
//

import UIKit

class ViewController: UIViewController, UITextFieldDelegate {

    @IBOutlet weak var stepper: UIStepper!
    @IBOutlet weak var countText: UITextField!
    
    var gooGooBerries : Int = 0
    var canceled : Bool = false
    
    override func viewDidLoad() {
        super.viewDidLoad()
        gooGooBerries = UserDefaults.standard.integer(forKey: "gooGooBeries") 

        stepper.transform = stepper.transform.scaledBy(x: 2, y: 2)
        stepper.value = Double(gooGooBerries)
        stepper.setDecrementImage(stepper.decrementImage(for: .normal), for: .normal)
        stepper.setIncrementImage(stepper.incrementImage(for: .normal), for: .normal)
        stepper.tintColor = .white

        countText.delegate = self
        
        self.addDoneButtonOnKeyboard()

        updateCount(count: gooGooBerries)
    }

    @IBAction func stepCounterPressed(_ sender: UIStepper) {
        updateCount(count: Int(sender.value))
    }
    
    private func updateCount(count : Int){
        gooGooBerries = count
        if gooGooBerries > 9999 { gooGooBerries = 9999 }
        countText.text = String(count)
        stepper.value = Double(count)
        UserDefaults.standard.set(count, forKey: "gooGooBeries")
    }
}

//MARK: - TextField Functions

extension ViewController : UITextViewDelegate {

    func addDoneButtonOnKeyboard() {
        let doneToolbar: UIToolbar = UIToolbar(frame: CGRect(x: 0, y: 0, width: 320, height: 50))
        doneToolbar.barStyle = UIBarStyle.default
      
        let flexSpace = UIBarButtonItem(barButtonSystemItem: UIBarButtonItem.SystemItem.flexibleSpace, target: nil, action: nil)
        let done: UIBarButtonItem = UIBarButtonItem(title: "Done", style: UIBarButtonItem.Style.done, target: self, action: #selector(self.doneButtonAction))
        let cancel: UIBarButtonItem = UIBarButtonItem(title: "Cancel", style: UIBarButtonItem.Style.done, target: self, action: #selector(self.cancelButtonAction))

      var items = [UIBarButtonItem]()
      items.append(flexSpace)
      items.append(cancel)
      items.append(done)

      doneToolbar.items = items
      doneToolbar.sizeToFit()
      
      self.countText.inputAccessoryView = doneToolbar
      
    }
    
    @objc func doneButtonAction() {
      self.countText.resignFirstResponder()
        if let count = countText.text {
            updateCount(count: Int(count) ?? 0)
        }
    }

    @objc func cancelButtonAction() {
        canceled = true
        self.countText.resignFirstResponder()
        updateCount(count: gooGooBerries)
        canceled = false
    }

    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        if textField.text!.count > 3 {
                return false
        } else {
            return true
        }
    }

    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        true
    }

    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        view.endEditing(true)
        super.touchesBegan(touches, with: event)
    }
    
    func textFieldDidEndEditing(_ textField: UITextField, reason: UITextField.DidEndEditingReason) {
        print("here2")
        countText.resignFirstResponder()
        if canceled == true {
            return
        } else {
            if let count = countText.text {
                updateCount(count: Int(count) ?? 0)
            }
        }
    }
}

