//  Created by lubos plavucha on 02/12/14.
//  Copyright (c) 2014 Acepricot. All rights reserved.
//

import Foundation
import UIKit


open class BLabel: UILabel, BControl {

    
    fileprivate weak var object: NSObject!
    fileprivate var keyPath: String!
    fileprivate var bounded = false;
    
    
    open var validationFailed = false
    open var delegates: [BControlDelegate] = []
    
    
    deinit {
        delegates.removeAll()
    }
    
    
    open func bind(_ object: NSObject, keyPath: String) -> BLabel {
        
        if bounded {
            return self
        }
        
        self.object = object
        self.keyPath = keyPath
        self.object.addObserver(self, forKeyPath: keyPath, options: [.new, .old], context: nil)
        
        // set value immediately when being bound
        setValueFromModel(self.object.value(forKeyPath: keyPath) as? String)
        self.bounded = true
        
        return self
    }
    
    
    open func unbind() {
        // ui component needs to be unbound before managed object becomes invalid
        if bounded {
            self.object.removeObserver(self, forKeyPath: keyPath)
            bounded = false
        }
    }
    
    
    func setValueFromModel(_ value: String?) {
        self.text = value != nil ? value : ""
    }
    
    
//    func setValueFromComponent(value: String?) {
//        
//    }
    
    
    override open func observeValue(forKeyPath keyPath: String?, of object: Any?, change: [NSKeyValueChangeKey : Any]?, context: UnsafeMutableRawPointer?) {
        
        if self.object.isEqual(object) {
            setValueFromModel(change?[NSKeyValueChangeKey.newKey] as? String)
        }
    }
    
    public func validate() {
        
    }

}

