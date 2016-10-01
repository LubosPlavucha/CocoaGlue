//  Created by lubos plavucha on 05/12/14.
//  Copyright (c) 2014 Acepricot. All rights reserved.
//

import Foundation
import UIKit


public protocol BControl {
    
    
    var delegates: [BControlDelegate] {get set}
    var validationFailed: Bool {get set} 
    
    
    func validate()
    
    func unbind()
    
}
