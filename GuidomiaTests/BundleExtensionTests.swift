//
//  BundleExtensionTests.swift
//  GuidomiaTests
//
//  Created by Shilpa on 08/10/21.
//

import XCTest
@testable import Guidomia

class BundleExtensionTests: XCTestCase {

    let bundle = Bundle.main
    
    func testLoadJsonFileFromBundle() {
        let resultWithJson = bundle.decode([Vehicle].self, from: Constants.JsonFile.vehicleList, fileExtension: Constants.JsonFile.jsonExtension)
        XCTAssertTrue(try resultWithJson.get().count > 0)
        
        let resultWithoutJson = bundle.decode([Vehicle].self, from: "", fileExtension: "")
        XCTAssertNil(try? resultWithoutJson.get())
    }
}
