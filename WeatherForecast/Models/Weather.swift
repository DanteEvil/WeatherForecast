//
//  Weather.swift
//  WeatherForecast
//
//  Created by Truong Le on 2/1/21.
//

import Foundation

struct CachedWeatherResult: Codable {
    let searchText: String!
    let date: TimeInterval!
    let weather: Weather!
}

struct Weather: Codable, Equatable {
    let list: [WeatherByDay]!
}

struct WeatherByDay: Codable, Equatable {
    let date: Double!
    let temperature: Double!
    let pressure: Int!
    let humidity: Int!
    let weatherDescs: Array<WeatherDescription>!
    
    var overrall: String! {
        return weatherDescs.first?.description ?? ""
    }
    
    private enum CodingKeys: String, CodingKey {
        case dt
        case temp
        case pressure
        case humidity
        case weather
    }
    
    private enum TempKeys: String, CodingKey {
        case eve
    }
    
    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        date = try container.decode(Double.self, forKey: .dt)
        pressure = try container.decode(Int.self, forKey: .pressure)
        humidity = try container.decode(Int.self, forKey: .humidity)
        // Temperature
        let tempsContainer = try container.nestedContainer(keyedBy: TempKeys.self, forKey: .temp)
        temperature = try tempsContainer.decode(Double.self, forKey: .eve)
        
        // Weather description
        weatherDescs = try container.decode((Array<WeatherDescription>).self, forKey: .weather)
    }
    
    func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encode(date, forKey: .dt)
        try container.encode(pressure, forKey: .pressure)
        try container.encode(humidity, forKey: .humidity)
        try container.encode(weatherDescs, forKey: .weather)

        var tempsContainer = container.nestedContainer(keyedBy: TempKeys.self, forKey: .temp)
        try tempsContainer.encode(temperature, forKey: .eve)
    }
}

struct WeatherDescription: Codable, Equatable {
    let id: Int!
    let main: String!
    let description: String!
}
