//
//  UIView+Extension.swift
//  Guidomia
//
//  Created by Shilpa on 05/10/21.
//

import Foundation
import UIKit

extension UIView {
    
    ///sets the corner radius of the view to the new value
    @IBInspectable
    var cornerRadius: CGFloat {
        get {
            return self.layer.cornerRadius
        }
        set {
            self.layer.cornerRadius = newValue
        }
    }
}
