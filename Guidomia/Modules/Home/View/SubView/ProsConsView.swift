//
//  ProsConsView.swift
//  Guidomia
//
//  Created by Shilpa on 06/10/21.
//

import UIKit

class ProsConsView: UIView {

    //MARK:- IBOutlets
    @IBOutlet var prosConsTextLabel: UILabel!
    
    //MARK:- Helper functions
    /// class function to load the nib in another view
    /// - Returns: The current view class
    class func loadFromNib() -> ProsConsView? {
        return UINib(nibName: ProsConsView.reuseIdentifier,
                     bundle: nil).instantiate(withOwner: nil,
                                              options: nil).first as? ProsConsView
    }
    
    //MARK:- Initializer
    /// set the value as string in the label
    /// - Parameter value: string value
    func setContent(_ value: String) {
        self.prosConsTextLabel.text = value
    }
}
