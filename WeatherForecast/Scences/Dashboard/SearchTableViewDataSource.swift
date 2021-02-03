//
//  SearchTableViewDataSource.swift
//  WeatherForecast
//
//  Created by Truong Le on 2/3/21.
//

import Foundation
import UIKit

class SearchTableViewDataSource: NSObject {
    
    private var resultTableView: UITableView!
    private var result: [WeatherByDay] = [] {
        didSet {
            resultTableView.reloadData()
        }
    }
    
    init(tableView: UITableView) {
        super.init()
        self.resultTableView = tableView
        self.setupTableView(tableView)
    }
    
    private func setupTableView(_ tableView: UITableView) {
        tableView.register(UINib(nibName: WeatherInfoTableViewCell.reuseIdentifier, bundle: .main),
                                 forCellReuseIdentifier: WeatherInfoTableViewCell.reuseIdentifier)
        tableView.dataSource = self
        tableView.delegate = self
    }
    
    func reloadData(_ data: [WeatherByDay]) {
        result = data
    }
}

extension SearchTableViewDataSource: UITableViewDataSource, UITableViewDelegate {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return result.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: WeatherInfoTableViewCell.reuseIdentifier, for: indexPath)
        return cell
    }
    
    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        if let weatherCell = cell as? WeatherInfoTableViewCell {
            weatherCell.configCell(weather: result[indexPath.row])
        }
    }
}
