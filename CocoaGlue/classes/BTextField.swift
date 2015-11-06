//  Created by lubos plavucha on 04/12/14.
//  Copyright (c) 2014 Acepricot. All rights reserved.
//

import Foundation
import UIKit

public class BTextField: UITextField, BControlProtocol  {
    
    
    var object: NSObject!
    var keyPath: String!
    var formatter: NSFormatter?
    private var bounded = false;
    var modelBeingUpdated = false;
    
    
    
    public func bind(object: NSObject, keyPath: String, formatter: NSFormatter? = nil, placeholder: Bool? = false) -> BTextField {
        
        if bounded {
            return self
        }
        
        self.object = object
        self.keyPath = keyPath
        self.formatter = formatter
        // set value immediately when being bound
        setValueFromModel(object.valueForKeyPath(keyPath), placeholder: placeholder)
        
        self.object.addObserver(self, forKeyPath: keyPath, options: [.New, .Old], context: UnsafeMutablePointer<()>())
        self.addTarget(self, action: Selector("valueChanged"), forControlEvents: .EditingChanged)
        self.bounded = true 
        
        return self
    }
    
    
    public func unbind() {
        // ui component needs to be unbound before managed object becomes invalid
        if bounded {
            self.object.removeObserver(self, forKeyPath: keyPath)
            self.removeTarget(self, action: Selector("valueChanged"), forControlEvents: .ValueChanged)
            bounded = false
        }
    }
    
    
    func valueChanged() {
        setValueFromComponent(self.text)
    }
    
    
    func setValueFromComponent(value: String?) {
        modelBeingUpdated = true;
        let value = value != nil ? value!.stringByTrimmingCharactersInSet(NSCharacterSet.whitespaceCharacterSet()) : ""
        self.object.setValue(value, forKeyPath: self.keyPath)  // primitive setters must not be used
        modelBeingUpdated = false
    }
    
    
    func setValueFromModel(value: AnyObject?, placeholder: Bool? = false) {
        if (placeholder != nil && placeholder == true && value != nil) {
            self.placeholder = value as? String
        } else {
            self.text = value != nil ? value as! String : ""
        }
    }
    
    
    override public func observeValueForKeyPath(keyPath: String?, ofObject object: AnyObject?, change: [String : AnyObject]?, context: UnsafeMutablePointer<Void>) {
        
        if modelBeingUpdated {
            return
        }
        if self.object.isEqual(object) {
            setValueFromModel(change?[NSKeyValueChangeNewKey])
        }
    }
    
}
