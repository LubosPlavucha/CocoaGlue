//  Created by lubos plavucha on 10/12/14.
//  Copyright (c) 2014 Acepricot. All rights reserved.
//

import Foundation
import UIKit

open class BNumberTextField: BTextField {
    
    
    open var valueGreaterThan: NSDecimalNumber?
    open var validationMessageOnGreaterThan = ""
    open var validationMessageOnWrongFormat = ""
    
    
    
    override func initProperties() {
        super.initProperties()
        
        self.keyboardType = .numberPad
        
        // add toolbar with custom buttons
        let keyboardDoneButtonView = UIToolbar.init()
        keyboardDoneButtonView.sizeToFit()
        
        // add Minus Button
        let minusButtonFont = UIFont.boldSystemFont(ofSize: 22)
        let minusButton = UIBarButtonItem(title: "-", style: .plain, target: self, action: #selector(minusPressed))
        minusButton.setTitleTextAttributes([NSFontAttributeName: minusButtonFont], for: .normal)
        
        let spaceButton = UIBarButtonItem.init(barButtonSystemItem: .flexibleSpace, target: nil, action: nil)
        
        // add Done button
        let doneButton = UIBarButtonItem.init(barButtonSystemItem: .done, target: self, action: #selector(done))    
        
        keyboardDoneButtonView.items = [minusButton, spaceButton, doneButton]
        self.inputAccessoryView = keyboardDoneButtonView
    }
    
    
    func minusPressed() {
        if self.text == nil {
            self.text = "-"
        } else if !self.text!.contains("-") {
            self.text = "-" + self.text!
        }
        valueChanged()  // must call, because not called automatically
    }
    
    
    func done() {
        self.endEditing(true)
    }
    
    
    override func setValueFromComponent(_ value: String?) {
        assert(formatter != nil && formatter is NumberFormatter)
        
        modelBeingUpdated = true;
        
        let convertedValue = numberFromString(value!)
        if convertedValue == nil {
            // value has wrong format or is nil, empty -> set model to 0
            self.object.setValue(getDefaultValue(), forKeyPath: self.keyPath)
        } else {
            self.object.setValue(convertedValue!, forKeyPath: self.keyPath)
        }
        
        modelBeingUpdated = false;
    }
    
    
    override func setValueFromModel(_ value: AnyObject?, placeholder: Bool? = false) {
        assert(formatter != nil && formatter is NumberFormatter)
        
        if modelBeingUpdated {
            return
        }
        
        let placeholder = placeholder != nil && placeholder == true
        
        if value != nil {
            let convertedValue = (formatter as! NumberFormatter).string(from: value as! NSNumber)
            if (convertedValue == nil || placeholder) {
                // show placeholder if it is set or if conversion fails
                self.placeholder = convertedValue
            } else {
                self.text = convertedValue
            }
        } else {
            // show placeholder if it is wished, because there is no value
            self.placeholder = placeholder ? (formatter as! NumberFormatter).string(from: getDefaultValue()) : ""
        }
    }
    
    
    func numberFromString(_ value: String) -> NSNumber? {
        return (formatter as! NumberFormatter).number(from: value.trimmingCharacters(in: CharacterSet.whitespaces))
    }
    
    
    func getDefaultValue() -> NSNumber {
        return 0
    }
    
    
    override public func validate() {
        
        super.validate()
        
        if self.text == nil || self.text!.trimmingCharacters(in: CharacterSet.whitespaces).isEmpty || self.validationFailed {
            return  // return if there is no text or if the validation is failing already in super class
        }
        
        // validate minimal/maximal value
        let value = numberFromString(self.text!)
        
        if value == nil {
            
            // wrong number format
            self.validationFailed = true
            self.validationErrorLook = fieldBeingLeft ? true : false    // set validation error look only if the user is going to leave the field
            self.validationMessage = validationMessageOnGreaterThan
            
        } else if valueGreaterThan != nil && (value?.compare(valueGreaterThan!) == .orderedSame || value?.compare(valueGreaterThan!) == .orderedAscending) {
            
            // the actual value must be greater than the specified value; execute this validation on the input field leave, because it's not a good practice to execute this kind of validation on every text change
            
            self.validationFailed = true
            self.validationErrorLook = fieldBeingLeft ? true : false    // set validation error look only if the user is going to leave the field
            self.validationMessage = validationMessageOnGreaterThan
        }
    }

}
