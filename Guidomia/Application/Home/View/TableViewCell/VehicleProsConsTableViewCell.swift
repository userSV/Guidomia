//
//  VehicleProsConsTableViewCell.swift
//  Guidomia
//
//  Created by Shilpa on 06/10/21.
//

import UIKit

class VehicleProsConsTableViewCell: UITableViewCell {

    //MARK:- IBOutlets
    @IBOutlet var prosContainerView: UIView!
    @IBOutlet var consContainerView: UIView!
    @IBOutlet var prosLabelContainerStackView: UIStackView!
    @IBOutlet var consLabelContainerStackView: UIStackView!
    
    //MARK:- Properties
    private var prosViews = [ProsConsTextView]()
    private var consViews = [ProsConsTextView]()
    
    override func prepareForReuse() {
        super.prepareForReuse()
        //self.prosViews.removeAll()
       // self.consViews.removeAll()
        prosViews.forEach { view in
            view.removeFromSuperview()
        }
        consViews.forEach { view in
            view.removeFromSuperview()
        }
    }
    
    /// set data in the current view
    /// - Parameters:
    ///   - prosList: list of strings as pros
    ///   - consList: list of strings as cons
    func setData(prosList: [String], consList: [String]) {
        prosContainerView.isHidden = true
        consContainerView.isHidden = true
        if !prosList.isEmpty {
            prosContainerView.isHidden = false
            loadProsViewWith(pros: prosList)
        }
        if !consList.isEmpty {
            consContainerView.isHidden = false
            loadConsViewWith(cons: consList)
        }
    }
    
    /// load pros in the views
    /// - Parameter pros: list of strings as pros
    private func loadProsViewWith(pros: [String]) {
        for index in 0..<prosViews.count {
            self.prosLabelContainerStackView.removeArrangedSubview(prosViews[index])
            prosViews[index].removeFromSuperview()
        }
        for index in 0..<pros.count {
            self.prosViews.append(ProsConsTextView.loadFromNib())
            prosViews[index].setContent(pros[index])
            self.prosLabelContainerStackView.addArrangedSubview(prosViews[index])
        }
    }
    
    /// load cons in the views
    /// - Parameter cons: list of strings as cons
    private func loadConsViewWith(cons: [String]) {
        for index in 0..<consViews.count {
            self.consLabelContainerStackView.removeArrangedSubview(consViews[index])
            consViews[index].removeFromSuperview()
        }
        for index in 0..<cons.count {
            self.consViews.append(ProsConsTextView.loadFromNib())
            consViews[index].setContent(cons[index])
            self.consLabelContainerStackView.addArrangedSubview(consViews[index])
        }
    }
}
