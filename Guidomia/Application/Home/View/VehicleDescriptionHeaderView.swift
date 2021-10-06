//
//  VehicleDescriptionHeaderView.swift
//  Guidomia
//
//  Created by Shilpa on 05/10/21.
//

import UIKit
import Cosmos

class VehicleDescriptionHeaderView: UITableViewHeaderFooterView {

    //MARK:- IBOutlets
    @IBOutlet var vehicleImageView: UIImageView!
    @IBOutlet var vehicleNameLabel: UILabel!
    @IBOutlet var vehiclePriceLabel: UILabel!
    @IBOutlet var ratingView: CosmosView!

    //MARK:- Set Data
    func setDataWith(viewModel: VehicleDetailViewModel) {
        self.vehicleNameLabel.text = viewModel.name
        self.vehiclePriceLabel.text = viewModel.displayPrice
        self.ratingView.rating = Double(viewModel.rating ?? 0)
        if let image = viewModel.image {
            self.vehicleImageView.image = UIImage(named: image)
        }
    }
}

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
            return "\(Constants.VehicleInfo.priceText): \(formattedPrice)"
        }
        return "\(Constants.VehicleInfo.priceText): 0"
    }
    
    var name: String {
        if let make = make,
           let model = model {
            return make + " " + model
        }
        return ""
    }
}
