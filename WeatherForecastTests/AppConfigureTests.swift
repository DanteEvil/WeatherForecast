//
//  AppConfigureTests.swift
//  WeatherForecastTests
//
//  Created by Truong Le on 2/6/21.
//

import XCTest
@testable import WeatherForecast

class AppConfigureTests: XCTestCase {

    override func setUpWithError() throws {
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }

    override func tearDownWithError() throws {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
    }

    func test_AppConfigure_ProvideCorrectAPIKey() {
        let expectedApiKey = "60c6fbeb4b93ac653c492ba806fc346d"
        let apiKey = AppConfig.apiKey
        XCTAssertEqual(expectedApiKey, apiKey, "Expect API key equal \(expectedApiKey) but receive \(apiKey)")
    }
    
    func test_AppConfigure_ProvideCorrectUnitsValue() {
        let expectedUnit = "metric"
        let units = AppConfig.units
        XCTAssertEqual(expectedUnit, units, "Expect units equal \(expectedUnit) but receive \(units)")
    }
    
    func test_AppConfigure_ProvideCorrectNumberOfDays_ForReturnResult() {
        let expectedDays = 7
        let nums = AppConfig.numOfDays
        XCTAssertEqual(expectedDays, nums, "Expect number of days equal \(expectedDays) but receive \(nums)")
    }
    
    func test_AppConfigure_ProvideCorrectTimeInterval_ForAvailableCache() {
        let expected24h: TimeInterval = 86400
        let time = AppConfig.cacheAvailableLimitTime
        XCTAssertEqual(expected24h, time, "Expect time equal \(expected24h) but receive \(time)")
    }
}
