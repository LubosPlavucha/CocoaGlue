//  Created by lubos plavucha on 05/12/14.
//  Copyright (c) 2014 Acepricot. All rights reserved.
//

import Foundation

public class BDecimalTextField: BNumberTextField {
    

    
    
    override func numberFromString(value: String) -> NSNumber? {
        let number = (formatter as NSNumberFormatter).numberFromString(value.stringByTrimmingCharactersInSet(NSCharacterSet.whitespaceCharacterSet()))
        if number != nil {
            return NSDecimalNumber(string: number?.stringValue)
        } else {
            return nil
        }
    }
    
    
    override func getDefaultValue() -> NSNumber {
        return NSDecimalNumber.zero()
    }
}