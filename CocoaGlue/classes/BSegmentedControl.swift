//  Created by lubos plavucha on 04/12/14.
//  Copyright (c) 2014 Acepricot. All rights reserved.
//

import Foundation
import UIKit


private var segmentedControlContext = 0


public class BSegmentedControl: UISegmentedControl, BControlProtocol {
    
    
    private var object: NSObject!
    private var keyPath: String!
    private var values = [Int: AnyObject]()
    private var bounded = false;
    var modelBeingUpdated = false;
    
    
    
    public func bind(object: NSObject, keyPath: String, values: [Int: AnyObject]) -> BSegmentedControl {
        
        if bounded {
            return self
        }
        
        self.object = object
        self.keyPath = keyPath
        self.values = values
        
        // set value immediately when being bound
        setValueFromModel(self.object.valueForKeyPath(keyPath))
        
        self.object.addObserver(self, forKeyPath: keyPath, options: .New, context: &segmentedControlContext)
        self.addTarget(self, action: #selector(BSegmentedControl.valueChanged), forControlEvents: .ValueChanged)
        self.bounded = true
        return self
    }
    
    
    public func unbind() {
        // ui component needs to be unbound before managed object becomes invalid
        if bounded {
            self.object.removeObserver(self, forKeyPath: keyPath)
            self.removeTarget(self, action: #selector(BSegmentedControl.valueChanged), forControlEvents: .ValueChanged)
            bounded = false
        }
    }

    
    func setValueFromComponent(value: Int) {
        modelBeingUpdated = true;
        self.object.setValue(values[value], forKeyPath: self.keyPath)
        modelBeingUpdated = false;
    }
    
    
    func setValueFromModel(value: AnyObject?) {
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
    
    
    public override func observeValueForKeyPath(keyPath: String?, ofObject object: AnyObject?, change: [String : AnyObject]?, context: UnsafeMutablePointer<Void>) {
        
        if modelBeingUpdated {
            return
        }
        if context == &segmentedControlContext && self.object.isEqual(object) {
            setValueFromModel(change?[NSKeyValueChangeNewKey])
        }
    }

}
