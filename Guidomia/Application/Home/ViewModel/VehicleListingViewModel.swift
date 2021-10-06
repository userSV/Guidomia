//
//  VehicleListingViewModel.swift
//  Guidomia
//
//  Created by Shilpa on 06/10/21.
//

import Foundation

protocol VehicleListViewPresenter: AnyObject {
    func didReceiveVehiclesList()
    func didReceiveErrorOnVehiclesListFetch(errorMessage: String)
}

class VehicleListingViewModel {
    
    //MARK:- Properties
    private var vehicles = [Vehicle]()
    weak var viewDelegate: VehicleListViewPresenter?
    
    //MARK:- Initializer
    init(view: VehicleListViewPresenter) {
        self.viewDelegate = view
    }
    
    //MARK:- Helper Functions
    func getVehicleDetails() {
        let decoder = JSONDecoder()
        DispatchQueue.global().async {
            do {
                let jsonData = Data(vehicleListJson.utf8)
                let vehicles = try decoder.decode([Vehicle].self, from: jsonData)
                self.vehicles.append(contentsOf: vehicles)
                self.viewDelegate?.didReceiveVehiclesList()
            } catch(let error) {
                print(error)
                self.viewDelegate?.didReceiveErrorOnVehiclesListFetch(errorMessage: error.localizedDescription)
            }
        }
    }
    
    //MARK:- Data sources
    //returns the number of count of vehicles
    func numberOfSections() -> Int {
        return vehicles.count
    }
    
    /// returns the vehicle description view model at a particular section
    /// - Parameter section: current section index
    /// - Returns: visual representation of data
    func viewModelForVehicleAt(_ section: Int) -> VehicleDetailViewModel {
        let viewModel = VehicleDetailViewModel(name: self.vehicles[section].makeName, price: self.vehicles[section].customerPrice, rating: self.vehicles[section].rating)
        return viewModel
    }
}
