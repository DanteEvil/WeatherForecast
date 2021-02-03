//
//  WeatherAPIs.swift
//  WeatherForecast
//
//  Created by Truong Le on 2/1/21.
//

import Foundation
import Moya

enum WeatherAPIs {
    case DailyForecast(city: String)
}

extension WeatherAPIs: TargetType {
    var baseURL: URL {
        return URL(string: "https://api.openweathermap.org/data/2.5")!
    }
    
    var path: String {
        switch self {
        case .DailyForecast:
            return "/forecast/daily"
        }
    }
    
    var method: Moya.Method {
        switch self {
        case .DailyForecast: return .get
        }
    }
    
    var sampleData: Data {
        return Data()
    }
    
    var task: Task {
        switch self {
        case .DailyForecast: return .requestParameters(parameters: queryParams!, encoding: URLEncoding.queryString)
        }
    }
    
    var headers: [String : String]? {
        switch self {
        case .DailyForecast: return nil
        }
    }
    
    var queryParams: [String : Any]? {
        switch self {
        case .DailyForecast(let city):
            return ["q": city,
                    "cnt": AppConfig.numOfDays,
                    "appid": AppConfig.apiKey,
                    "units": AppConfig.units]
        }
    }
}
