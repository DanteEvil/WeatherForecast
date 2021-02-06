//
//  WeatherWebservices.swift
//  WeatherForecast
//
//  Created by Truong Le on 2/1/21.
//

import Foundation
import RxSwift
import Moya

class WeatherWebservices: WeatherWebservicesProtocol {
    let provider = MoyaProvider<WeatherAPIs>()
    
    func fetchWeatherForeCastOf(city: String, completion: @escaping ((Result<Weather?, Error>) -> Void)) {
        if let cache = SimpleCacheManager.getCacheFor(searchText: city) {
            if Date().timeIntervalSince1970 - cache.date < AppConfig.cacheAvailableLimitTime  {
                return completion(.success(cache.weather))
            } else {
                SimpleCacheManager.removeCacheFor(searchText: city)
                fetchWeatherForeCastIgnoreCacheOf(city: city, completion: completion)
            }
        } else {
            fetchWeatherForeCastIgnoreCacheOf(city: city, completion: completion)
        }
        
    }
    
    func fetchWeatherForeCastIgnoreCacheOf(city: String, completion: @escaping ((Result<Weather?, Error>) -> Void)) {
        provider.request(.DailyForecast(city: city)) { (result) in
            switch result {
            case .success(let response):
                if response.statusCode == 200 {
                    do {
                        let weather = try JSONDecoder().decode(Weather.self, from: response.data)
                        SimpleCacheManager.save(result: CachedWeatherResult(searchText: city,
                                                                            date: Date().timeIntervalSince1970,
                                                                            weather: weather))
                        completion(.success(weather))
                    } catch {
                        completion(.failure(error))
                    }
                } else {
                    completion(.failure(WFErrors.WebserviceFailed))
                }
            case .failure(let error):
                completion(.failure(error))
            }
        }
    }
}
