//  Created by lubos plavucha on 05/12/14.
//  Copyright (c) 2014 Acepricot. All rights reserved.
//

import Foundation
import UIKit


open class BSwitch: UISwitch, BControl {
    
    
    fileprivate weak var object: NSObject!
    fileprivate var keyPath: String!
    fileprivate var bounded = false;
    
    
    open var validationFailed = false
    open var delegates: [BControlDelegate] = []
    
    
    deinit {
        delegates.removeAll()
    }
    
    
    open func bind(_ object: NSObject, keyPath: String) -> BSwitch {
        
        if bounded {
            return self
        }
        
        self.object = object
        self.keyPath = keyPath
        self.object.addObserver(self, forKeyPath: keyPath, options: [.new, .old], context: nil)
        
        // set value immediately when being bound
        setValueFromModel(object.value(forKeyPath: keyPath) as? Bool as NSNumber?)
        
        self.addTarget(self, action: #selector(BSwitch.valueChanged), for: .valueChanged)
        self.bounded = true
        
        return self
    }
    
    
    open func unbind() {
        // ui component needs to be unbound
        if bounded {
            self.removeTarget(self, action: #selector(BSwitch.valueChanged), for: .valueChanged)
            self.object.removeObserver(self, forKeyPath: keyPath)
            bounded = false
        }
    }
    
    
    func valueChanged() {
        setValueFromComponent(self.isOn)
    }
    
    
    func setValueFromComponent(_ value: Bool?) {
        self.object.setValue(value != nil ? NSNumber(value: value! as Bool) : NSNumber(value: false as Bool), forKeyPath: self.keyPath)
    }
    
    
    func setValueFromModel(_ value: NSNumber?) {
        self.isOn = value != nil ? (value == 1 ? true : false) : false
    }
    
    
    override open func observeValue(forKeyPath keyPath: String?, of object: Any?, change: [NSKeyValueChangeKey : Any]?, context: UnsafeMutableRawPointer?) {
        
        if self.object.isEqual(object) {
            setValueFromModel(change?[NSKeyValueChangeKey.newKey] as? NSNumber)
        }
    }
    
    
    public func validate() {
        
    }
    
}
