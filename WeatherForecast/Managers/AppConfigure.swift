//
//  AppConfig.swift
//  WeatherForecast
//
//  Created by Truong Le on 2/1/21.
//

import Foundation

class AppConfig {
    private init() {}
}

extension AppConfig {
    static let cacheAvailableLimitTime: TimeInterval = 24*60*60 // Allow data to be cached for 24h
    
    // API constants
    static let numOfDays = 7
    static let apiKey: String = "60c6fbeb4b93ac653c492ba806fc346d"
    static let units: String = "metric"
}
