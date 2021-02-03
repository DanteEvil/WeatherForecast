//
//  WFErrors.swift
//  WeatherForecast
//
//  Created by Truong Le on 2/2/21.
//

import Foundation

enum WFErrors: LocalizedError {
    case WebserviceFailed
    case ParsingDataFailed
    case NoResult
    
    var errorDescription: String? {
        switch self {
        case .WebserviceFailed:
            return "Internal server error"
        case .ParsingDataFailed:
            return "Somethings went wrong"
        case .NoResult:
            return "No result found"
        }
    }
}
