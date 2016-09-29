//  Created by lubos plavucha on 04/12/14.
//  Copyright (c) 2014 Acepricot. All rights reserved.
//

import Foundation
import UIKit

open class BTextField: UITextField, BControlProtocol  {
    
    
    weak var object: NSObject!
    var keyPath: String!
    var formatter: Formatter?
    open var bounded = false
    var modelBeingUpdated = false
    
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        initProperties()
    }
    
    required public init?(coder: NSCoder) {
        super.init(coder: coder)
        initProperties()
    }
    
    
    func initProperties() {
    }
    
    
    open func bind(_ object: NSObject, keyPath: String, formatter: Formatter? = nil, placeholder: Bool? = false) -> BTextField {
        
        if bounded {
            return self
        }
        
        self.object = object
        self.keyPath = keyPath
        self.formatter = formatter
        
        // set value immediately when being bound
        setValueFromModel(object.value(forKeyPath: keyPath) as AnyObject?, placeholder: placeholder)
        
        // add listener for changes from the model
        self.object.addObserver(self, forKeyPath: keyPath, options: [.new, .old], context: nil)
        
        // add listener for changes from the user
        self.addTarget(self, action: #selector(BTextField.valueChanged), for: .editingChanged)
        
        self.bounded = true 
        
        return self
    }
    
    
    open func unbind() {
        // ui component needs to be unbound before managed object becomes invalid
        if bounded {
            self.object.removeObserver(self, forKeyPath: keyPath)
            self.removeTarget(self, action: #selector(BTextField.valueChanged), for: .editingChanged)
            bounded = false
        }
    }
    
    
    func valueChanged() {
        setValueFromComponent(self.text)
    }
    
    
    func setValueFromComponent(_ value: String?) {
        modelBeingUpdated = true;
        let value = value != nil ? value!.trimmingCharacters(in: CharacterSet.whitespaces) : ""
        self.object.setValue(value, forKeyPath: self.keyPath)  // primitive setters must not be used
        modelBeingUpdated = false
    }
    
    
    func setValueFromModel(_ value: AnyObject?, placeholder: Bool? = false) {
        if (placeholder != nil && placeholder == true && value != nil) {
            self.placeholder = value as? String
        } else {
            self.text = value != nil ? value as! String : ""
        }
    }
    
    
    override open func observeValue(forKeyPath keyPath: String?, of object: Any?, change: [NSKeyValueChangeKey : Any]?, context: UnsafeMutableRawPointer?) {
        
        let change = change?[NSKeyValueChangeKey.newKey]
        
        guard !modelBeingUpdated && !(change is NSNull) else {
            return
        }

        setValueFromModel(change as AnyObject?)
    }
    
}
