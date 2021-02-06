//
//  WeatherWebservicesProtocol.swift
//  WeatherForecast
//
//  Created by Truong Le on 2/6/21.
//

import Foundation

protocol WeatherWebservicesProtocol {
    func fetchWeatherForeCastOf(city: String, completion: @escaping ((Result<Weather?, Error>) -> Void))
    func fetchWeatherForeCastIgnoreCacheOf(city: String, completion: @escaping ((Result<Weather?, Error>) -> Void))
}
