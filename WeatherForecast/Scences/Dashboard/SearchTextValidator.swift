//
//  SearchTextValidator.swift
//  WeatherForecast
//
//  Created by Truong Le on 2/6/21.
//

import Foundation

class SearchTextValidator {
    static func validate(searchText: String) -> Bool {
        return searchText.count >= 3
    }
}
