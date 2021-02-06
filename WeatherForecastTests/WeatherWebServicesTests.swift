//
//  WeatherWebServicesTests.swift
//  WeatherForecastTests
//
//  Created by Truong Le on 2/6/21.
//

import XCTest
@testable import WeatherForecast

class WeatherWebServicesTests: XCTestCase {
    let requestTimeOut: TimeInterval = 10
    let webServices = WeatherWebservices()
    let searchText = "tha"
    let time: TimeInterval = 1612607396
    let mockSearchData = "{\"city\":{\"id\":1654379,\"name\":\"Tha\",\"coord\":{\"lon\":105.7212,\"lat\":14.9604},\"country\":\"LA\",\"population\":88332,\"timezone\":25200},\"cod\":\"200\",\"message\":5.3980115,\"cnt\":7,\"list\":[{\"dt\":1612587600,\"sunrise\":1612567487,\"sunset\":1612609057,\"temp\":{\"day\":32.65,\"min\":18.2,\"max\":34.37,\"night\":23.48,\"eve\":31.17,\"morn\":18.2},\"feels_like\":{\"day\":33.47,\"night\":23.9,\"eve\":32.1,\"morn\":19.38},\"pressure\":1013,\"humidity\":37,\"weather\":[{\"id\":800,\"main\":\"Clear\",\"description\":\"sky is clear\",\"icon\":\"01d\"}],\"speed\":1.69,\"deg\":330,\"clouds\":2,\"pop\":0},{\"dt\":1612674000,\"sunrise\":1612653870,\"sunset\":1612695482,\"temp\":{\"day\":35.23,\"min\":19.36,\"max\":35.82,\"night\":27.66,\"eve\":29.42,\"morn\":19.36},\"feels_like\":{\"day\":37.22,\"night\":29.17,\"eve\":30.56,\"morn\":20.43},\"pressure\":1011,\"humidity\":33,\"weather\":[{\"id\":801,\"main\":\"Clouds\",\"description\":\"few clouds\",\"icon\":\"02d\"}],\"speed\":0.27,\"deg\":216,\"clouds\":15,\"pop\":0.07},{\"dt\":1612760400,\"sunrise\":1612740253,\"sunset\":1612781907,\"temp\":{\"day\":34.57,\"min\":21.86,\"max\":34.57,\"night\":22.57,\"eve\":24.71,\"morn\":21.86},\"feels_like\":{\"day\":36.93,\"night\":25.91,\"eve\":27.34,\"morn\":23.28},\"pressure\":1009,\"humidity\":37,\"weather\":[{\"id\":500,\"main\":\"Rain\",\"description\":\"light rain\",\"icon\":\"10d\"}],\"speed\":0.46,\"deg\":160,\"clouds\":42,\"pop\":0.84,\"rain\":5.07},{\"dt\":1612846800,\"sunrise\":1612826634,\"sunset\":1612868332,\"temp\":{\"day\":27.27,\"min\":21.17,\"max\":27.27,\"night\":21.19,\"eve\":21.17,\"morn\":21.79},\"feels_like\":{\"day\":28.82,\"night\":23.72,\"eve\":23.76,\"morn\":24.96},\"pressure\":1011,\"humidity\":61,\"weather\":[{\"id\":501,\"main\":\"Rain\",\"description\":\"moderate rain\",\"icon\":\"10d\"}],\"speed\":2.46,\"deg\":7,\"clouds\":98,\"pop\":0.82,\"rain\":8.22},{\"dt\":1612933200,\"sunrise\":1612913014,\"sunset\":1612954755,\"temp\":{\"day\":31.14,\"min\":19.01,\"max\":31.74,\"night\":22.83,\"eve\":25.43,\"morn\":19.01},\"feels_like\":{\"day\":31.67,\"night\":23.35,\"eve\":25.44,\"morn\":20.4},\"pressure\":1010,\"humidity\":43,\"weather\":[{\"id\":500,\"main\":\"Rain\",\"description\":\"light rain\",\"icon\":\"10d\"}],\"speed\":2.67,\"deg\":329,\"clouds\":16,\"pop\":0.61,\"rain\":0.21},{\"dt\":1613019600,\"sunrise\":1612999393,\"sunset\":1613041179,\"temp\":{\"day\":32.07,\"min\":18.79,\"max\":32.37,\"night\":22.39,\"eve\":25.31,\"morn\":18.79},\"feels_like\":{\"day\":31.12,\"night\":21.68,\"eve\":23.93,\"morn\":19.56},\"pressure\":1010,\"humidity\":31,\"weather\":[{\"id\":802,\"main\":\"Clouds\",\"description\":\"scattered clouds\",\"icon\":\"03d\"}],\"speed\":2.6,\"deg\":340,\"clouds\":32,\"pop\":0},{\"dt\":1613106000,\"sunrise\":1613085771,\"sunset\":1613127601,\"temp\":{\"day\":32.9,\"min\":18.42,\"max\":32.9,\"night\":22.18,\"eve\":25.24,\"morn\":18.59},\"feels_like\":{\"day\":31.49,\"night\":21.01,\"eve\":24.09,\"morn\":18.96},\"pressure\":1010,\"humidity\":25,\"weather\":[{\"id\":800,\"main\":\"Clear\",\"description\":\"sky is clear\",\"icon\":\"01d\"}],\"speed\":2.18,\"deg\":334,\"clouds\":0,\"pop\":0}]}".data(using: .utf8)!
    
    override func setUpWithError() throws {
        // Clean cache for search result
        SimpleCacheManager.removeCacheFor(searchText: searchText)
    }

    override func tearDownWithError() throws {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
    }

    func testFetchWeatherForeCast_WithCacheAvailable_ShouldReturnTheSameCacheData() {
        let expectation = self.expectation(description: "Response expectation")
        let mockSearchResult = try! JSONDecoder().decode(Weather.self, from: mockSearchData)
        let mockCache = CachedWeatherResult(searchText: searchText,
                                            date: time,
                                            weather: mockSearchResult)
        SimpleCacheManager.save(result: mockCache)
        webServices.fetchWeatherForeCastOf(city: searchText) { (result) in
            switch result {
            case .success(let weather):
                XCTAssertEqual(weather, mockSearchResult, "Expect request return the same provided mock data but it returns a different result")
                expectation.fulfill()
            case .failure:
                XCTFail("Expect request return the same cache data but it's failed")
            }
        }
        self.wait(for: [expectation], timeout: requestTimeOut)
    }
    
    func testFetchWeatherForeCast_WithCacheNotAvailable_ShouldReturnExpectedResult() {
        let expectation = self.expectation(description: "Response expectation")
        let mockSearchResult = try! JSONDecoder().decode(Weather.self, from: mockSearchData)
        webServices.fetchWeatherForeCastOf(city: searchText) { (result) in
            switch result {
            case .success(let weather):
                XCTAssertNotEqual(weather, mockSearchResult, "Expect request return the different result because cache has been clean but it returns the same result")
                expectation.fulfill()
            case .failure:
                XCTFail("Expect request return result but it's failed")
            }
        }
        self.wait(for: [expectation], timeout: requestTimeOut)
    }
    
    func testFetchWeatherForeCast_IgnoreCache_ShouldReturnResultOnTime() {
        let expectation = self.expectation(description: "Response expectation")
        webServices.fetchWeatherForeCastIgnoreCacheOf(city: searchText) { (result) in
            switch result {
            case .success(let weather):
                XCTAssertNotNil(weather, "Expect request return result on time but receive nil")
                XCTAssertNotNil(weather!.list.count > 0, "Expect request return result on time but receive empty list")
                expectation.fulfill()
            case .failure:
                XCTFail("Expect request return result but it's failed")
            }
        }
        self.wait(for: [expectation], timeout: requestTimeOut)
    }
    
    func testFetchWeatherForeCast_IgnoreCache_ShouldReturnResultOnTime_DifferentWithCachedData() {
        let expectation = self.expectation(description: "Response expectation")
        let mockSearchResult = try! JSONDecoder().decode(Weather.self, from: mockSearchData)
        let mockCache = CachedWeatherResult(searchText: searchText,
                                            date: time,
                                            weather: mockSearchResult)
        SimpleCacheManager.save(result: mockCache)
        webServices.fetchWeatherForeCastIgnoreCacheOf(city: searchText) { (result) in
            switch result {
            case .success(let weather):
                XCTAssertNotEqual(weather, mockSearchResult, "Expect request ignore cache should returns different result with cache but it returns the same result")
                expectation.fulfill()
            case .failure:
                XCTFail("Expect request return result but it's failed")
            }
        }
        self.wait(for: [expectation], timeout: requestTimeOut)
    }
}
