//
//  DashboardViewController.swift
//  WeatherForecast
//
//  Created by Truong Le on 2/1/21.
//

import UIKit

class DashboardViewController: UIViewController {
    private var viewModel: DashboardViewViewModel!
    private var dataSource: SearchTableViewDataSource!
    
    @IBOutlet weak var searchFieldWrapper: UIView!
    @IBOutlet weak var searchTextField: UITextField!
    @IBOutlet weak var cancelButton: UIButton!
    @IBOutlet weak var searchTableView: UITableView!
    @IBOutlet weak var errorWrapper: UIView!
    @IBOutlet weak var errorLabel: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        dataSource = SearchTableViewDataSource(tableView: searchTableView)
        let webservices = WeatherWebservices()
        viewModel = DashboardViewViewModel(webServices: webservices)
        viewModel.layout(view: self)
        viewModel.setupBinding(view: self)
    }
    
    @IBAction func onCancelSearching(_ sender: Any) {
        searchTextField.text = nil
        searchTextField.sendActions(for: .editingChanged)
    }
    
    func reloadData(_ result: [WeatherByDay]) {
        dataSource.reloadData(result)
    }
}
