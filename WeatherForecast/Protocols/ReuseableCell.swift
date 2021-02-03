//
//  ReuseableCell.swift
//  WeatherForecast
//
//  Created by Truong Le on 2/2/21.
//

import Foundation
import UIKit

protocol ReuseableCell {
    static var reuseIdentifier: String {get}
}

extension UITableViewCell: ReuseableCell {
    static var reuseIdentifier: String {
        return String(describing: self)
    }    
}
