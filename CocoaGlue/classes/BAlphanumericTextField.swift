//
//  BAlphanumericTextField.swift
//  CocoaGlue
//
//  Created by lubos plavucha on 01/10/16.
//  Copyright © 2016 lubos plavucha. All rights reserved.
//

import Foundation


public class BAlphanumericTextField: BTextField {
    
    
    var validationMessageOnWrongFormat = ""

    
    override public func validate() {
        
        super.validate()
        
        if self.text == nil || self.text!.trimmingCharacters(in: CharacterSet.whitespaces).isEmpty || self.validationFailed {
            return  // return if there is no text or if the validation is failing already in super class
        }
        
        // validate alpha-numeric format
        let alphanumericCharacters = CharacterSet.alphanumerics
        let nonAlphanumeric = (text!.components(separatedBy: alphanumericCharacters) as NSArray).componentsJoined(by: "") 
        
        if !nonAlphanumeric.isEmpty {
            // the text contains at least 1 non-alphanumeric character
            self.validationFailed = true
            self.validationErrorLook = true
            self.validationMessage = validationMessageOnWrongFormat
        }
    }
}
