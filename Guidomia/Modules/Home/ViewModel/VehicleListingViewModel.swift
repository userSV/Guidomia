//
//  VehicleListingViewModel.swift
//  Guidomia
//
//  Created by Shilpa on 06/10/21.
//

import Foundation

protocol VehicleListViewDelegate: AnyObject {
    func didReceiveVehiclesList()
    func didReceiveErrorOnVehiclesListFetch(errorMessage: String)
    func updateViewState(isExpanded: Bool, atIndex index: Int)
    func didUpdateFilterList()
}

class VehicleListingViewModel {
    
    //MARK:- Properties
    /// store the list of all vehicles
    private var vehicles = [Vehicle]()
    weak var viewDelegate: VehicleListViewDelegate?
    private var selectedMake: String?
    private var selectedModel: String?
    /// stores the list of filtered vehicles
    private var filteredVehicles = [Vehicle]()
    /// will return true if the filter is selected , else return false
    var isFilterApplied: Bool {
        if selectedMake != nil || selectedModel != nil {
            return true
        }
        return false
    }
    ///returns the vehicle list according to filters applied
    private var vehiclesList: [Vehicle] {
        return !isFilterApplied ? self.vehicles : self.filteredVehicles
    }
    
    //MARK:- Initializer
    func initializeWith(delegate: VehicleListViewDelegate) {
        self.viewDelegate = delegate
    }
    
    //MARK:- Helper Functions
    /// fetch the details from json file
    func getVehicleDetails() {
        DispatchQueue.global().async {
            let result = Bundle.main.decode([Vehicle].self, from: Constants.JsonFile.vehicleList, fileExtension: Constants.JsonFile.jsonExtension)
            switch result {
            case .success(var vehicles):
                let filteredList = self.filterProsConsList(vehicles: &vehicles)
                self.vehicles.append(contentsOf: filteredList)
                self.viewDelegate?.didReceiveVehiclesList()
            case .failure(let error):
                self.viewDelegate?.didReceiveErrorOnVehiclesListFetch(errorMessage: error.localizedDescription)
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
    
    /// set the selected make value
    /// - Parameter value: value as string
    func setSelectedMake(value: String?) {
        self.selectedMake = value
        filterVehiclesListWithMakeAndModel()
    }
    
    /// set the selected model value
    /// - Parameter value: value as string
    func setSelectedModel(value: String?) {
        self.selectedModel = value
        filterVehiclesListWithMakeAndModel()
    }
    
    /// Filter the list of vehicles on the basis of their make and model
    private func filterVehiclesListWithMakeAndModel() {
        if selectedMake != nil && selectedModel != nil {
            self.filteredVehicles = self.vehicles.filter {$0.makeName == selectedMake && $0.modelName == selectedModel}
        } else if selectedMake != nil || selectedModel != nil {
            self.filteredVehicles = self.vehicles.filter {$0.makeName == selectedMake || $0.modelName == selectedModel}
        } else {
            self.filteredVehicles.removeAll()
        }
        self.viewDelegate?.didUpdateFilterList()
    }
}

//MARK:- Data sources
extension VehicleListingViewModel {
    
    // returns the number of count of vehicles
    func numberOfVehicles() -> Int {
        return vehiclesList.count
    }
    
    /// will return true if the vehicle has pros and/or cons , else return false
    /// - Parameter index: current index of the vehicle
    /// - Returns: true or false
    func isExpanded(index: Int) -> Bool {
        
        if self.vehiclesList[index].prosList == nil && self.vehiclesList[index].consList == nil {
            return false
        }
        return vehiclesList[index].isExpanded
    }
    
    /// returns the vehicle description view model at a particular section
    /// - Parameter index: current section index
    /// - Returns: visual representation of data
    func viewModelForVehicleAt(_ index: Int) -> VehicleDetailViewModel {
        
        let viewModel = VehicleDetailViewModel(make: self.vehiclesList[index].makeName,
                                               price: self.vehiclesList[index].customerPrice,
                                               rating: self.vehiclesList[index].rating,
                                               image: self.vehiclesList[index].image,
                                               model: self.vehiclesList[index].modelName)
        return viewModel
    }
    
    /// returns the pros list at index
    /// - Parameter index: index of view
    /// - Returns: array of string
    func prosListAt(index: Int) -> [String] {
        return self.vehiclesList[index].prosList ?? []
    }
    
    /// returns the cons list at index
    /// - Parameter index: index of view
    /// - Returns: array of string
    func consListAt(index: Int) -> [String] {
        return self.vehiclesList[index].consList ?? []
    }
    
    /// Changes the state of expanded from true to false or vice-versa
    /// - Parameters:
    ///   - index: current index
    ///   - lastSelectedIndex: previous selected index
    func toggleOpenStateAt(index: Int, lastSelectedIndex: Int) {
        if index != lastSelectedIndex {
            // the current selected index is not the same as the previous one
            // change the expanded state of previous index
            self.vehicles[lastSelectedIndex].isExpanded = false
        }
        let isExpanded = self.vehiclesList[index].isExpanded
        if isFilterApplied {
            filteredVehicles[index].isExpanded = !isExpanded
        } else {
            vehicles[index].isExpanded = !isExpanded
        }
        self.viewDelegate?.updateViewState(isExpanded: self.vehiclesList[index].isExpanded,
                                           atIndex: index)
    }
}
