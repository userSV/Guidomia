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
    func updateViewState(isExpanded: Bool, atIndex index: Int)
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
    /// fetch the details from json file
    func getVehicleDetails() {
        DispatchQueue.global().async {
            if var vehicles = Bundle.main.decode([Vehicle].self, from: Constants.JsonFile.vehicleList, fileExtension: "json") {
                let filteredList = self.filterProsConsList(vehicles: &vehicles)
                self.vehicles.append(contentsOf: filteredList)
                self.viewDelegate?.didReceiveVehiclesList()
            }
        }
    }
    
    /// filter the non-empty pros and cons list from the decoded json
    /// - Parameter vehicles: vehicles array decoded
    /// - Returns: vehicles array with empty data removed
    private func filterProsConsList(vehicles: inout [Vehicle]) -> [Vehicle] {
        for index in 0..<vehicles.count {
            if index == 0 {
                vehicles[index].isExpanded = true
            }
            vehicles[index].prosList = vehicles[index].prosList?.filter {$0 != ""}
            vehicles[index].consList = vehicles[index].consList?.filter {$0 != ""}
        }
        return vehicles
    }
    
    //MARK:- Data sources
    //returns the number of count of vehicles
    func numberOfSections() -> Int {
        return vehicles.count
    }
    
    /// returns the number of rows at a section
    func numberOfRowsAt(section: Int) -> Int {
        if self.vehicles[section].prosList == nil && self.vehicles[section].consList == nil {
            return 0
        }
        return vehicles[section].isExpanded ? 1 : 0
    }
    
    /// returns the vehicle description view model at a particular section
    /// - Parameter section: current section index
    /// - Returns: visual representation of data
    func viewModelForVehicleAt(_ section: Int) -> VehicleDetailViewModel {
        let viewModel = VehicleDetailViewModel(make: self.vehicles[section].makeName, price: self.vehicles[section].customerPrice, rating: self.vehicles[section].rating, image: self.vehicles[section].image, model: self.vehicles[section].modelName)
        return viewModel
    }
    
    /// returns the pros list at index
    /// - Parameter index: index of view
    /// - Returns: array of string
    func prosListAt(index: Int) -> [String] {
        return self.vehicles[index].prosList ?? []
    }
    
    /// returns the cons list at index
    /// - Parameter index: index of view
    /// - Returns: array of string
    func consListAt(index: Int) -> [String] {
        return self.vehicles[index].consList ?? []
    }
    
    func toggleOpenStateAt(index: Int, lastSelectedIndex: Int) {
        if index != lastSelectedIndex {
            //the current selected index is not the same as the previous one, then change the expanded state of previous index
            //self.vehicles[lastSelectedIndex].isExpanded = false
        }
        let isExpanded = self.vehicles[index].isExpanded
        self.vehicles[index].isExpanded = !isExpanded
        self.viewDelegate?.updateViewState(isExpanded: self.vehicles[index].isExpanded, atIndex: index)
    }
    
    /// returns the makes of all vehicles in an array
    /// - Returns: array of strings
    func makesListOfVehicles() -> [String] {
        return self.vehicles.map {$0.makeName ?? ""}
    }
    
    /// returns the models of all vehicles in an array
    /// - Returns: array of strings
    func modelListOfVehicles() -> [String] {
        return self.vehicles.map {$0.modelName ?? ""}
    }
}
