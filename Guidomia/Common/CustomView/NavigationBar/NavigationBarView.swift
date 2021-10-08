//
//  NavigationBar.swift
//  Guidomia
//
//  Created by Shilpa on 08/10/21.
//

import UIKit

protocol NavigationBarViewDelegate: AnyObject {
    func didClickOnRightButton()
}

class NavigationBarView: UIView {

    //MARK:- IBOutlets
    @IBOutlet var titleLabel: UILabel!
    @IBOutlet var rightActionButton: UIButton!
    
    //MARK:- Properties
    weak var delegate: NavigationBarViewDelegate?
    var enableRightButton: Bool = false {
        didSet {
            self.rightActionButton.isEnabled = enableRightButton
        }
    }
    
    //MARK:- IBActions
    @IBAction func rightButtonTapped(sender: UIButton) {
        self.delegate?.didClickOnRightButton()
    }
}
