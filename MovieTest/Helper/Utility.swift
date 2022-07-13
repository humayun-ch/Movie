//
//  Utility.swift
//  MovieTest
//
//  Created by Macbook Pro on 7/13/22.
//

import Foundation
import UIKit

class Utility: NSObject{
    
    class func convertHeightMultiplier(constant : CGFloat) -> CGFloat{
        let value = constant/896
        return value*UIScreen.main.bounds.height
    }
    
    class func convertWidthMultiplier(constant : CGFloat) -> CGFloat{
        let value = constant/414
        return value*UIScreen.main.bounds.width
    }
}
