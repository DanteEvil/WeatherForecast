//
//  SimpleCacheManager.swift
//  WeatherForecast
//
//  Created by Truong Le on 2/4/21.
//

import Foundation

class SimpleCacheManager {
    static func save(result: CachedWeatherResult) {
        if let data = try? JSONEncoder().encode(result) {
            UserDefaults.standard.setValue(data, forKey: result.searchText)
            UserDefaults.standard.synchronize()
        }
    }
    
    static func removeCacheFor(searchText: String) {
        UserDefaults.standard.setValue(nil, forKey: searchText)
        UserDefaults.standard.synchronize()
    }
    
    static func getCacheFor(searchText: String) -> CachedWeatherResult? {
        if let data = UserDefaults.standard.value(forKey: searchText) as? Data,
           let cache = try? JSONDecoder().decode(CachedWeatherResult.self, from: data) {
           return cache
        } else {
            return nil
        }
    }
}
