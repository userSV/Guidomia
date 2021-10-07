//
//  ProsConsTextView.swift
//  Guidomia
//
//  Created by Shilpa on 06/10/21.
//

import UIKit

class ProsConsTextView: UIView {

    //MARK:- IBOutlets
    @IBOutlet var prosConsTextLabel: UILabel!
    
    //MARK:- Helper functions
    /// class function to load the nib in another view
    /// - Returns: The current view class
    class func loadFromNib() -> ProsConsTextView {
        return UINib(nibName: ProsConsTextView.reuseIdentifier, bundle: nil).instantiate(withOwner: nil, options: nil)[0] as! ProsConsTextView
    }
    
    //MARK:- Initializer
    /// set the value as string in the label
    /// - Parameter value: string value
    func setContent(_ value: String) {
        self.prosConsTextLabel.text = value
    }
}
