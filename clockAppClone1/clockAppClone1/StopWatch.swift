//
//  StopWatch.swift
//  clockAppClone1
//
//  Created by Mitchell Park on 2/24/20.
//  Copyright © 2020 Mitchell Park. All rights reserved.
//

import UIKit

class StopWatch: UITableViewController {
    
    var delegate: CountryInfoDataSource?

    var countries: [String] = []
    let CELL_ID = "CELL_ID"
    
    override func viewDidLoad() {
        super.viewDidLoad()
        styleNavBar()
        configureTableView()
        getCities()
    }

    func getCities(){
        if let filepath = Bundle.main.path(forResource: "countries", ofType: "txt") {
            do {
                let contents = try String(contentsOfFile: filepath)
                countries = contents.components(separatedBy: .newlines)
            } catch {
                print("Houston we have a problem.")
            }
        } else {
            print("Houston we have another problem.")
        }
    }
    
    func styleNavBar(){        navigationController!.navigationBar.tintColor = .green
        navigationController!.navigationBar.prefersLargeTitles = true
        let appearance = UINavigationBarAppearance()
        appearance.titleTextAttributes = [.foregroundColor: UIColor.white]
        appearance.largeTitleTextAttributes = [.foregroundColor: UIColor.white]
        appearance.backgroundColor = .black
        navigationItem.standardAppearance = appearance
        navigationItem.compactAppearance = appearance
        navigationItem.scrollEdgeAppearance = appearance
        navigationItem.leftBarButtonItem = editButtonItem
        navigationItem.title = "All Cities"
        
    }
    
    func configureTableView(){
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: CELL_ID)
    }

}
extension StopWatch{
    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return countries.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: CELL_ID, for: indexPath)
        cell.textLabel?.text = countries[indexPath.row]
        return cell
    }
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let vc = CountryInfo()
        delegate = vc
        delegate?.configureTitle(title: countries[indexPath.row])
        navigationController!.pushViewController(vc, animated: true)
    }
    override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        return true
    }
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete{
            countries.remove(at: indexPath.row)
            tableView.beginUpdates()
            tableView.deleteRows(at: [indexPath], with: .automatic)
            tableView.endUpdates()
        }
    }
    
    override func tableView(_ tableView: UITableView, moveRowAt sourceIndexPath: IndexPath, to destinationIndexPath: IndexPath) {
        let selectedRow = countries[sourceIndexPath.row]
        countries.insert(selectedRow, at: destinationIndexPath.row)
        countries.remove(at: sourceIndexPath.row)
    }
    
}

protocol CountryInfoDataSource {
    func configureTitle(title: String)
}

class CountryInfo: UIViewController, CountryInfoDataSource {
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .cyan
        styleNavBar()
    }
    func styleNavBar(){
        let appearance = UINavigationBarAppearance()
        appearance.backgroundColor = .black
        appearance.titleTextAttributes = [.foregroundColor:UIColor.white]
        appearance.largeTitleTextAttributes = [.foregroundColor: UIColor.white]
        navigationController!.navigationBar.standardAppearance = appearance
        navigationController!.navigationBar.compactAppearance = appearance
        navigationController!.navigationBar.scrollEdgeAppearance = appearance
    }
    func configureTitle(title: String) {
        navigationItem.title = title
    }
}
