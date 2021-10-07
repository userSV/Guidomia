//
//  Utility.swift
//  Guidomia
//
//  Created by Shilpa on 07/10/21.
//

import Foundation
import UIKit

class Utility {
    
    /// show alert controller
    /// - Parameters:
    ///   - title: title of the alert
    ///   - message: message of the alert
    ///   - parentVC: parent view on which alert is to be presented
    ///   - action: action handler
    static func showAlertWith(title: String = "", message: String, parentVC: UIViewController, action: @escaping () -> ()) {
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        let okAction = UIAlertAction(title: Constants.AlertTitle.ok, style: .default) { _ in
            action()
        }
        alert.addAction(okAction)
        let cancelAction = UIAlertAction(title: Constants.AlertTitle.cancel, style: .default, handler: nil)
        alert.addAction(cancelAction)
        parentVC.present(alert, animated: true, completion: nil)
    }
}
