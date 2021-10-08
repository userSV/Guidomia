//
//  VehicleDetailViewModelTests.swift
//  GuidomiaTests
//
//  Created by Shilpa on 08/10/21.
//

import XCTest
@testable import Guidomia

class VehicleDetailViewModelTests: XCTestCase {

    var viewModel = VehicleDetailViewModel(make: "BMW",
                                           price: 123000,
                                           rating: 3,
                                           image: nil,
                                           model: nil)
    
    func testVehicleDisplayPrice() {
        XCTAssertEqual(viewModel.displayPrice, "\(Constants.VehicleInfo.priceText) : 123k")
    }
    
    func testVehicleDetailForEmptyPrice() {
        viewModel.price = nil
        XCTAssertEqual(viewModel.displayPrice, "\(Constants.VehicleInfo.priceText) : 0")
    }
    
    func testVehicleNameForEmptyMakeModel() {
        viewModel.make = nil
        viewModel.model = nil
        XCTAssertEqual(viewModel.name, "")
    }

}
