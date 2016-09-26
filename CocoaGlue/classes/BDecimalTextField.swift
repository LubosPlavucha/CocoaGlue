//  Created by lubos plavucha on 05/12/14.
//  Copyright (c) 2014 Acepricot. All rights reserved.
//

import Foundation
import UIKit

open class BDecimalTextField: BNumberTextField {
    
    
    
    override func initProperties() {
        super.initProperties()
        self.keyboardType = .decimalPad
    }
    
    
    override func numberFromString(_ value: String) -> NSNumber? {
        let number = (formatter as! NumberFormatter).number(from: value.trimmingCharacters(in: CharacterSet.whitespaces))
        if number != nil {
            return NSDecimalNumber(string: number?.stringValue)
        } else {
            return nil
        }
    }
    
    
    override func getDefaultValue() -> NSNumber {
        return NSDecimalNumber.zero
    }
}
