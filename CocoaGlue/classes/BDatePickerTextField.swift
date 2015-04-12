//  Created by lubos plavucha on 06/12/14.
//  Copyright (c) 2014 Acepricot. All rights reserved.
//

import Foundation
import UIKit

public class BDatePickerTextField: BTextField {
    
    
    private var datePicker: UIDatePicker!
    
    
    required public init(coder: NSCoder) {
        super.init(coder: coder)
        datePicker = UIDatePicker()
        datePicker.datePickerMode = .Date;
        datePicker.addTarget(self, action: Selector("dateChanged"), forControlEvents: .ValueChanged)
        self.inputView = datePicker
    }
    

    func dateChanged() {
        assert(formatter != nil && formatter is NSDateFormatter)
        
        // sets value from date picker both to entity and text field
        modelBeingUpdated = true;
        self.object.setValue(datePicker.date, forKeyPath: self.keyPath)
        self.text = (formatter as! NSDateFormatter).stringFromDate(datePicker.date)
        modelBeingUpdated = false;
    }
    
    
    override func setValueFromComponent(value: String?) {
        // should not be implemented - text field change event should do nothing, because date picker takes control
    }
    
    
    override func setValueFromModel(value: AnyObject?, placeholder: Bool? = false) {
        assert(formatter != nil && formatter is NSDateFormatter)
        
        if modelBeingUpdated {
            return
        }
        let placeholder = placeholder != nil && placeholder == true
        
        // TODO crashing sometime -> even if it shows here it is not nil - in fact, there is hidden null pointer -> reproduce this when trying to set date to nil
        if value is NSDate {
            self.text = (formatter as! NSDateFormatter).stringFromDate(value as! NSDate)
            datePicker.date = value as! NSDate
        } else {
            // show placeholder if it is wished, because there is no value
            self.placeholder = placeholder ? (formatter as! NSDateFormatter).dateFormat : ""
        }
    }
}
