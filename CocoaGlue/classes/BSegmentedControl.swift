//  Created by lubos plavucha on 04/12/14.
//  Copyright (c) 2014 Acepricot. All rights reserved.
//

import Foundation
import UIKit


private var segmentedControlContext = 0


open class BSegmentedControl: UISegmentedControl, BControlProtocol {
    
    
    fileprivate var object: NSObject!
    fileprivate var keyPath: String!
    fileprivate var values = [Int: AnyObject]()
    fileprivate var bounded = false;
    var modelBeingUpdated = false;
    
    
    
    open func bind(_ object: NSObject, keyPath: String, values: [Int: AnyObject]) -> BSegmentedControl {
        
        if bounded {
            return self
        }
        
        self.object = object
        self.keyPath = keyPath
        self.values = values
        
        // set value immediately when being bound
        setValueFromModel(self.object.value(forKeyPath: keyPath) as AnyObject?)
        
        self.object.addObserver(self, forKeyPath: keyPath, options: .new, context: &segmentedControlContext)
        self.addTarget(self, action: #selector(BSegmentedControl.valueChanged), for: .valueChanged)
        self.bounded = true
        return self
    }
    
    
    open func unbind() {
        // ui component needs to be unbound before managed object becomes invalid
        if bounded {
            self.object.removeObserver(self, forKeyPath: keyPath)
            self.removeTarget(self, action: #selector(BSegmentedControl.valueChanged), for: .valueChanged)
            bounded = false
        }
    }

    
    func setValueFromComponent(_ value: Int) {
        modelBeingUpdated = true;
        self.object.setValue(values[value], forKeyPath: self.keyPath)
        modelBeingUpdated = false;
    }
    
    
    func setValueFromModel(_ value: AnyObject?) {
        if value != nil {
            // get key based on value -> this key is segmeted control index
            for (key, valueDict) in values {
                if valueDict.isEqual(value) {
                    self.selectedSegmentIndex = key
                    return
                }
            }
        }
    }
    
    
    func valueChanged() {
        setValueFromComponent(self.selectedSegmentIndex)
    }
    
    
    open override func observeValue(forKeyPath keyPath: String?, of object: Any?, change: [NSKeyValueChangeKey : Any]?, context: UnsafeMutableRawPointer?) {
        
        if modelBeingUpdated {
            return
        }
        if context == &segmentedControlContext && self.object.isEqual(object) {
            setValueFromModel(change?[NSKeyValueChangeKey.newKey] as AnyObject?)
        }
    }

}
