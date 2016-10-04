//  Created by lubos plavucha on 04/12/14.
//  Copyright (c) 2014 Acepricot. All rights reserved.
//

import Foundation
import UIKit

open class BTextField: UITextField, BControl  {
    
    
    weak var object: NSObject!
    var keyPath: String!
    open var formatter: Formatter?
    open var bounded = false
    var modelBeingUpdated = false
    
    // --- validation properties ---------------------
    
    open var required = false
    open var minimalTextLength: Int?
    open var maximalTextLength: Int?
    
    /** Marks the validation status of the field. */
    open var validationFailed = false
    open var validationMessage = ""    
    /** Message to be displayed if the 'required' validation fails. To be set by the calling code. */
    open var validationMessageOnRequired = ""
    
    var validationErrorLook = false
    var valueBeingChanged = false
    var fieldBeingLeft = false
    
    open var delegates: [BControlDelegate] = []
    
    // --- end of validation properties --------------
    
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        initProperties()
    }
    
    required public init?(coder: NSCoder) {
        super.init(coder: coder)
        initProperties()
    }
    
    
    func initProperties() {
        // always add listeners for changes from the GUI
        self.addTarget(self, action: #selector(BTextField.valueChanged), for: .editingChanged)
        self.addTarget(self, action: #selector(BTextField.fieldEndEditing), for: .editingDidEnd)
    }
    
    
    deinit {
        self.delegates.removeAll()
        self.removeTarget(nil, action: nil, for: .allEvents)    // this should remove all the targets, incl. those set from outside of this class 
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
        
        self.bounded = true 
        
        return self
    }
    
    
    open func unbind() {
        // ui component needs to be unbound before managed object becomes invalid
        if bounded {
            // TODO check if it is possible to remove this automatically, e.g. in deinit or listens the managed object deinitialization and remove myself at that time -> this will remove the need to call this function form the client code !!!
            self.object.removeObserver(self, forKeyPath: keyPath)
            bounded = false
        }
    }
    
    
    open func getBoundedObject() -> NSObject {
        return object
    }
    
    
    func valueChanged() {
        
        valueBeingChanged = true
        
        validate()
        
        if self.validationErrorLook  {
            setValidationErrorLook()
        } else {
            removeValidationErrorLook()
        }
        
        if !self.validationFailed {
            setValueFromComponent(self.text)
        }

        for delegate in delegates {
            delegate.validationStateCheck(self.validationFailed)
        }
        
        valueBeingChanged = false
    }
    
    
    func fieldEndEditing() {
        
        fieldBeingLeft = true
        
        validate()
        
        if self.validationErrorLook  {
            setValidationErrorLook()
        } else {
            removeValidationErrorLook()
        }
        
        for delegate in delegates {
            delegate.validationStateCheck(self.validationFailed)
        }
        
        fieldBeingLeft = false
    }
    
    
    func setValueFromComponent(_ value: String?) {
        
        if !bounded {
            return
        }
        
        modelBeingUpdated = true
        
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
    
    
    /** Performs the validation. The function is to be overriden/extended by subclasses to include additional validations. Returns the string currently being entered in the field. */
    public func validate() {
        
        if self.text == nil {
            return
        }
        
        // clear
        self.validationFailed = false
        self.validationErrorLook = false
        self.validationMessage = ""
        
        // validate required
        if required && text!.trimmingCharacters(in: CharacterSet.whitespaces).isEmpty {
            
            self.validationFailed = true
            self.validationErrorLook = true
            self.validationMessage = validationMessageOnRequired
        }        
    }
    
    
    fileprivate func setValidationErrorLook() {
        
        self.layer.borderWidth = 1
        self.layer.borderColor = UIColor.red.cgColor
        self.layer.cornerRadius = 5.0
    }
    
    
    fileprivate func removeValidationErrorLook() {
        self.layer.borderColor = UIColor.clear.cgColor
    }
    
}
