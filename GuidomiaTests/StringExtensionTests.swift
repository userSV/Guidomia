//
//  StringExtensionTests.swift
//  GuidomiaTests
//
//  Created by Shilpa on 08/10/21.
//

import XCTest
@testable import Guidomia

class StringExtensionTests: XCTestCase {

    private let separator = " "
    private let firstString = "Range"
    
    func testStringConcatenation() {
        let result = firstString.concatenateWith(separator: separator, list: ["Rover"])
        XCTAssertEqual(result, "\(firstString) Rover")
    }
    
    func testStringConcatenationForEmptyOtherString() {
        let result = firstString.concatenateWith(separator: separator, list: [])
        XCTAssertEqual(result, firstString)
    }
    
    func testStringFormat() {
        let result = firstString.formattedForThousand()
        XCTAssertEqual(result, "0")
    }
}
