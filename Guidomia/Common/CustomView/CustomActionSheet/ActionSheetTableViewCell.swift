//
//  ActionSheetTableViewCell.swift
//  Guidomia
//
//  Created by Shilpa on 07/10/21.
//

import UIKit

class ActionSheetTableViewCell: UITableViewCell {

    //MARK:- IBOutlets
    @IBOutlet var contentLabel: UILabel!
    
    //MARK:- View Life Cycle
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

   //MARK:- Initialization
    /// set data in the label
    /// - Parameter value: string
    func setData(_ value: String) {
        self.contentLabel.text = value
    }
    
}
