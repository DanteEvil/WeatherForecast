//
//  SearchTextValidatorTests.swift
//  WeatherForecastTests
//
//  Created by Truong Le on 2/6/21.
//

import XCTest
@testable import WeatherForecast

class SearchTextValidatorTests: XCTestCase {

    override func setUpWithError() throws {
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }

    override func tearDownWithError() throws {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
    }

    func test_validator_shouldReturnFalse_IfProvided_InvalidSearchText() {
        let invalidSearchText = "ho"
        let validateResult = SearchTextValidator.validate(searchText: invalidSearchText)
        XCTAssertFalse(validateResult, "Expect validator return false but receive \(validateResult)")
    }
    
    func test_validator_shouldReturnTrue_IfProvided_ValidSearchText() {
        let validSearchText = "SaiGon"
        let validateResult = SearchTextValidator.validate(searchText: validSearchText)
        XCTAssertTrue(validateResult, "Expect validator return true but receive \(validateResult)")
    }
}
