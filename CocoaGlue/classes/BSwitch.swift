//  Created by lubos plavucha on 05/12/14.
//  Copyright (c) 2014 Acepricot. All rights reserved.
//

import Foundation
import UIKit


public class BSwitch: UISwitch, BControlProtocol {
    
    
    private var object: NSObject!
    private var keyPath: String!
    private var bounded = false;
    
    
    
    public func bind(object: NSObject, keyPath: String) -> BSwitch {
        
        if bounded {
            return self
        }
        
        self.object = object
        self.keyPath = keyPath
        self.object.addObserver(self, forKeyPath: keyPath, options: [.New, .Old], context: nil)
        
        // set value immediately when being bound
        setValueFromModel(object.valueForKeyPath(keyPath) as? Bool)
        
        self.addTarget(self, action: #selector(BSwitch.valueChanged), forControlEvents: .ValueChanged)
        self.bounded = true
        
        return self
    }
    
    
    public func unbind() {
        // ui component needs to be unbound
        if bounded {
            self.removeTarget(self, action: #selector(BSwitch.valueChanged), forControlEvents: .ValueChanged)
            self.object.removeObserver(self, forKeyPath: keyPath)
            bounded = false
        }
    }
    
    
    func valueChanged() {
        setValueFromComponent(self.on)
    }
    
    
    func setValueFromComponent(value: Bool?) {
        self.object.setValue(value != nil ? NSNumber(bool: value!) : NSNumber(bool: false), forKeyPath: self.keyPath)
    }
    
    
    func setValueFromModel(value: NSNumber?) {
        self.on = value != nil ? (value == 1 ? true : false) : false
    }
    
    
    override public func observeValueForKeyPath(keyPath: String?, ofObject object: AnyObject?, change: [String : AnyObject]?, context: UnsafeMutablePointer<Void>) {
        
        if self.object.isEqual(object) {
            setValueFromModel(change?[NSKeyValueChangeNewKey] as? NSNumber)
        }
    }
    
}
