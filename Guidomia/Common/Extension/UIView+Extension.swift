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
    
    /// Adds shadow to the view
    /// - Parameters:
    ///   - radius: shadow radius, defaults to 3
    ///   - color: shadow color, defaults to black
    ///   - opacity: shadow opacity, defaults to 60%
    ///   - offset: shadow offset, defaults to zero
    func addShadow(radius: CGFloat? = 3, color: UIColor? = .black, opacity: Float? = 0.6, offset: CGSize? = .zero) {
        self.layer.shadowColor = color!.cgColor
        self.layer.shadowOpacity = opacity!
        self.layer.shadowOffset = offset!
        self.layer.shadowRadius = radius!
    }
    
    /// returns the name of the calling class which can be used as the reuse identifier for tableview  views
    static var reuseIdentifier: String {
        return String(describing: self)
    }
}
