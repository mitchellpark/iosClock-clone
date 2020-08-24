//
//  WCCountryAdder.swift
//  clockAppClone1
//
//  Created by Mitchell Park on 2/27/20.
//  Copyright © 2020 Mitchell Park. All rights reserved.
//

import UIKit

class WCCountryAdder: UIViewController {
    
    var delegate: DataDelegate?
    let countries = [
        Country(name: "Korea", time: "8:04"),
        Country(name: "Russia", time: "6:04"),
        Country(name: "USA", time: "5:02"),
        Country(name: "Brazil", time: "9:04"),
        Country(name: "Argentina", time: "12:01")
    ]
    let CELL_ID = "CELLID"
    let tableView = UITableView()

    override func viewDidLoad() {
        super.viewDidLoad()
        styleNavBar()
        configureTableView()
    }
    
    func styleNavBar(){
        navigationController!.navigationBar.backgroundColor = .gray
        let searchController = UISearchController(searchResultsController: SearchResultsVC())
        navigationItem.prompt = "Pick a country."
        //let appearance = UINavigationBarAppearance()
        
        navigationItem.searchController = searchController
        navigationItem.searchController?.searchBar.searchBarStyle = .minimal
        navigationItem.searchController?.searchBar.showsCancelButton = true
        navigationItem.searchController?.searchBar.barTintColor = .orange
        navigationItem.searchController?.searchBar.barStyle = .default
        navigationItem.searchController?.searchBar.prompt = "there are many countries."
        navigationItem.searchController?.searchBar.placeholder = "Your country."
    }
    
    func configureTableView(){
        tableView.delegate = self
        tableView.dataSource = self
        view.addSubview(tableView)
        tableView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            tableView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            tableView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            tableView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor),
            tableView.trailingAnchor.constraint(equalTo: view.trailingAnchor)
        ])
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: CELL_ID)
    }

}
extension WCCountryAdder: UITableViewDelegate, UITableViewDataSource{
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return countries.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: CELL_ID, for: indexPath)
        cell.textLabel?.text = countries[indexPath.row].name
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        delegate?.addCountry(country: countries[indexPath.row])
        dismiss(animated: true, completion: nil)
    }
}

class SearchResultsVC: UIViewController{
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .cyan
    }
}
