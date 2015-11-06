//  Created by lubos plavucha on 02/12/14.
//  Copyright (c) 2014 Acepricot. All rights reserved.
//

import Foundation
import UIKit


public class BLabel: UILabel, BControlProtocol {

    
    private var object: NSObject!
    private var keyPath: String!
    private var bounded = false;
    
    
    
    public func bind(object: NSObject, keyPath: String) -> BLabel {
        
        if bounded {
            return self
        }
        
        self.object = object
        self.keyPath = keyPath
        self.object.addObserver(self, forKeyPath: keyPath, options: [.New, .Old], context: UnsafeMutablePointer<()>())
        
        // set value immediately when being bound
        setValueFromModel(self.object.valueForKeyPath(keyPath) as? String)
        self.bounded = true
        
        return self
    }
    
    
    public func unbind() {
        // ui component needs to be unbound before managed object becomes invalid
        if bounded {
            self.object.removeObserver(self, forKeyPath: keyPath)
            bounded = false
        }
    }
    
    
    func setValueFromModel(value: String?) {
        self.text = value != nil ? value : ""
    }
    
    
//    func setValueFromComponent(value: String?) {
//        
//    }
    
    
    override public func observeValueForKeyPath(keyPath: String?, ofObject object: AnyObject?, change: [String : AnyObject]?, context: UnsafeMutablePointer<Void>) {
        
        if self.object.isEqual(object) {
            setValueFromModel(change?[NSKeyValueChangeNewKey] as? String)
        }
    }

}

