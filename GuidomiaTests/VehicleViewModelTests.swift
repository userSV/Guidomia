//
//  VehicleViewModelTests.swift
//  GuidomiaTests
//
//  Created by Shilpa on 08/10/21.
//

import XCTest
@testable import Guidomia

class VehicleViewModelTests: XCTestCase {
    
    //MARK:- Properties
    let viewModel = VehicleListingViewModel()
    var vehicles = [Vehicle(modelName: "Range Rover",
                            makeName: "Land Rover",
                            customerPrice: 120000.0,
                            marketPrice: 125000.0,
                            rating: 3,
                            consList: ["Bad direction"],
                            prosList: ["You can go everywhere","Good sound system", ""],
                            image: nil,
                            isExpanded: false),
                    Vehicle(modelName: "Roadster",
                            makeName: "Alpine",
                            customerPrice: 220000.0,
                            marketPrice: 225000.0,
                            rating: 3,
                            consList: ["Sometime explode", "", ""],
                            prosList: ["This car is so fast","Jame Bond would love to steal that car","",""],
                            image: nil,
                            isExpanded: false)]
    let vehicleMake = "Range"
    let vehicleModel = "BMW"

    //MARK:- Tests
    func testFilterProsConsList() {
        
        let result = viewModel.filterProsConsList(vehicles: &vehicles)
        XCTAssertNotNil(result.first?.prosList)
        if let prosList = result.first?.prosList {
            XCTAssertEqual(prosList, ["You can go everywhere", "Good sound system"])
        }
    }
    
    func testSetSelectedMake() {
        
        let viewModel = VehicleListingViewModel()
        viewModel.setSelectedMake(value: vehicleMake)
        XCTAssertEqual(viewModel.selectedMake, vehicleMake)
    }
    
    func testSetSelectedModel() {
        
        viewModel.setSelectedModel(value: vehicleModel)
        viewModel.setSelectedMake(value: vehicleMake)
        XCTAssertEqual(viewModel.selectedModel, vehicleModel)
        XCTAssertEqual(viewModel.selectedMake, vehicleMake)
    }
    
    func testMakesListOfVehicles() {
        
        viewModel.vehicles = vehicles
        let result = viewModel.makesListOfVehicles()
        XCTAssertTrue(result.count > 0)
    }
    
    func testModelListOfVehicles() {
        
        viewModel.vehicles = vehicles
        let result = viewModel.modelListOfVehicles()
        XCTAssertTrue(result.count > 0)
    }
    
    func testToggleOpenStateAt() {
        
        viewModel.vehicles = vehicles
        viewModel.toggleOpenStateAt(index: 0, lastSelectedIndex: 0)
        guard let vehicle = viewModel.vehicles.first else {return}
        XCTAssertEqual(vehicle.isExpanded, true)
    }
    
    func testToggleOpenStateAtAtDifferentIndex() {
        
        viewModel.vehicles = vehicles
        viewModel.toggleOpenStateAt(index: 0, lastSelectedIndex: 1)
        guard let vehicle = viewModel.vehicles.first else {return}
        XCTAssertEqual(vehicle.isExpanded, true)
    }
    
    func testToggleOpenStateAtForFilteredList() {
        
        viewModel.filteredVehicles = vehicles
        viewModel.selectedMake = vehicleMake
        viewModel.selectedModel = vehicleModel
        viewModel.toggleOpenStateAt(index: 0, lastSelectedIndex: 0)
        guard let vehicle = viewModel.vehicles.first else {return}
        XCTAssertEqual(vehicle.isExpanded, true)
    }
    
    func testToggleStateForEmptyProsCons() {
        
        vehicles[0].consList = []
        vehicles[0].prosList = []
        viewModel.vehicles = vehicles
        viewModel.filteredVehicles = vehicles
        viewModel.selectedMake = vehicleMake
        viewModel.selectedModel = vehicleModel
        viewModel.toggleOpenStateAt(index: 0, lastSelectedIndex: 0)
        guard let vehicle = viewModel.vehicles.first else {return}
        XCTAssertEqual(vehicle.isExpanded, vehicles.first?.isExpanded ?? false)
    }
    
    func testIsExpanded() {
        
        vehicles[0].prosList = []
        vehicles[0].consList = []
        viewModel.vehicles = vehicles
        let result = viewModel.isExpanded(index: 0)
        XCTAssertEqual(result, false)
    }
}
