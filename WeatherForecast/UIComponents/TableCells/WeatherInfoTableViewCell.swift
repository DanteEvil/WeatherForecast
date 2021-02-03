//
//  WeatherInfoTableViewCell.swift
//  WeatherForecast
//
//  Created by Truong Le on 2/2/21.
//

import UIKit

class WeatherInfoTableViewCell: UITableViewCell {
    
    private var dateFormatter = DateFormatter()
    
    @IBOutlet weak var dateLabel: UILabel!
    @IBOutlet weak var tempLabel: UILabel!
    @IBOutlet weak var preLabel: UILabel!
    @IBOutlet weak var humLabel: UILabel!
    @IBOutlet weak var desLabel: UILabel!
    
    func configCell(weather: WeatherByDay) {
        dateFormatter.dateFormat = "EEE, dd MMM yyyy"
        dateLabel.text = String(format: "Date: %@", dateFormatter.string(from: Date(timeIntervalSince1970: weather.date)))
        tempLabel.text = String(format: "Average Temperature: %d°C", Int(weather.temperature))
        preLabel.text = String(format: "Pressure: %d", weather.pressure)
        humLabel.text = String(format: "Humidity: %d%", weather.humidity)
        desLabel.text = String(format: "Description: %@", weather.overrall)
    }
}
