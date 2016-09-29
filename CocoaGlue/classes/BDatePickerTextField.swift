//  Created by lubos plavucha on 06/12/14.
//  Copyright (c) 2014 Acepricot. All rights reserved.
//

import Foundation
import UIKit

open class BDatePickerTextField: BTextField {
    
    
    open weak var listener : BDatePickerTextFieldProtocol?
    fileprivate var datePicker: UIDatePicker!
    
    
    
    public required init?(coder: NSCoder) {
        super.init(coder: coder)
        datePicker = UIDatePicker()
        datePicker.datePickerMode = .date;
        datePicker.addTarget(self, action: #selector(BDatePickerTextField.dateChanged), for: .valueChanged)
        self.inputView = datePicker
    }
    

    func dateChanged() {
        assert(formatter != nil && formatter is DateFormatter)
        
        // sets value from date picker both to entity and text field
        modelBeingUpdated = true;
        self.object.setValue(datePicker.date, forKeyPath: self.keyPath)
        self.text = (formatter as! DateFormatter).string(from: datePicker.date)
        modelBeingUpdated = false;
        listener?.dateChanged()
    }
    
    
    override func setValueFromComponent(_ value: String?) {
        // should not be implemented - text field change event should do nothing, because date picker takes control
    }
    
    
    override func setValueFromModel(_ value: AnyObject?, placeholder: Bool? = false) {
        assert(formatter != nil && formatter is DateFormatter)
        
        if modelBeingUpdated {
            return
        }
        let placeholder = placeholder != nil && placeholder == true
        
        // TODO crashing sometime -> even if it shows here it is not nil - in fact, there is hidden null pointer -> reproduce this when trying to set date to nil
        if value is NSDate {
            self.text = (formatter as! DateFormatter).string(from: value as! Date)
            datePicker.date = value as! Date
        } else {
            // show placeholder if it is wished, because there is no value
            self.placeholder = placeholder ? (formatter as! DateFormatter).dateFormat : ""
        }
    }
}
