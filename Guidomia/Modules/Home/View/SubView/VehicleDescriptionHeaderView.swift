//
//  VehicleDescriptionHeaderView.swift
//  Guidomia
//
//  Created by Shilpa on 05/10/21.
//

import UIKit
import Cosmos

protocol VehicleSectionTapDelegate: AnyObject {
    func didTapOnSectionAt(index: Int)
}

class VehicleDescriptionHeaderView: UITableViewHeaderFooterView {

    //MARK:- Properties
    weak var sectionTapDelegate: VehicleSectionTapDelegate?
    
    //MARK:- IBOutlets
    @IBOutlet var vehicleImageView: UIImageView!
    @IBOutlet var vehicleNameLabel: UILabel!
    @IBOutlet var vehiclePriceLabel: UILabel!
    @IBOutlet var ratingView: CosmosView!
    @IBOutlet var containerView: UIView!
    
    override class func awakeFromNib() {
        super.awakeFromNib()
    }
    
    private func setTapGesture() {
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(didTapOnView(recognizer:)))
        tapGesture.numberOfTapsRequired = 1
        containerView.addGestureRecognizer(tapGesture)
    }

    //MARK:- Set Data
    /// set data in the views
    /// - Parameters:
    ///   - viewModel: visual representation of data
    ///   - index: current index of view
    func setDataWith(viewModel: VehicleDetailViewModel, atIndex index: Int) {
        self.containerView.tag = index
        self.setTapGesture()
        self.vehicleNameLabel.text = viewModel.name
        self.vehiclePriceLabel.text = viewModel.displayPrice
        self.ratingView.rating = Double(viewModel.rating ?? 0)
        if let image = viewModel.image {
            self.vehicleImageView.image = UIImage(named: image)
        }
    }
    
    //FIXME:- Fix
    @objc func didTapOnView(recognizer: UITapGestureRecognizer) {
        self.sectionTapDelegate?.didTapOnSectionAt(index: self.containerView.tag)
    }
}

/// View Model with vehicle data
struct VehicleDetailViewModel {
    var make: String?
    var price: Double?
    var rating: Float?
    var image: String?
    var model: String?
    
    /// display price formatted
    var displayPrice: String {
        if let price = price {
            let priceToInt = Int(price)
            let formattedPrice = String(priceToInt).formattedForThousand() ?? "0"
            return "\(Constants.VehicleInfo.priceText) : \(formattedPrice)"
        }
        return "\(Constants.VehicleInfo.priceText) : 0"
    }
    
    /// display name by concatenating make and model
    var name: String {
        if let make = make,
           let model = model {
            return make.concatenateWith(separator: " ",
                                        list: [model])
        }
        return ""
    }
}
