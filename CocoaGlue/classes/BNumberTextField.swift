//  Created by lubos plavucha on 10/12/14.
//  Copyright (c) 2014 Acepricot. All rights reserved.
//

import Foundation
import UIKit

public class BNumberTextField: BTextField {
    
    
    
    
    override func setValueFromComponent(value: String?) {
        assert(formatter != nil && formatter is NSNumberFormatter)
        
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
    
    
    override func setValueFromModel(value: AnyObject?, placeholder: Bool? = false) {
        assert(formatter != nil && formatter is NSNumberFormatter)
        
        if modelBeingUpdated {
            return
        }
        
        let placeholder = placeholder != nil && placeholder == true
        
        if value != nil {
            let convertedValue = (formatter as! NSNumberFormatter).stringFromNumber(value as! NSNumber)
            if (convertedValue == nil || placeholder) {
                // show placeholder if it is set or if conversion fails
                self.placeholder = convertedValue
            } else {
                self.text = convertedValue
            }
        } else {
            // show placeholder if it is wished, because there is no value
            self.placeholder = placeholder ? (formatter as! NSNumberFormatter).stringFromNumber(getDefaultValue()) : ""
        }
    }
    
    
    func numberFromString(value: String) -> NSNumber? {
        return (formatter as! NSNumberFormatter).numberFromString(value.stringByTrimmingCharactersInSet(NSCharacterSet.whitespaceCharacterSet()))
    }
    
    
    func getDefaultValue() -> NSNumber {
        return 0
    }

}
