//
//  BControlDelegate.swift
//  CocoaGlue
//
//  Created by lubos plavucha on 01/10/16.
//  Copyright © 2016 lubos plavucha. All rights reserved.
//

import Foundation


public protocol BControlDelegate {
    
    
    /** Invoked by BControl if its validation state might have changed. */
    func validationStateCheck(_ validationFailed: Bool)
}
