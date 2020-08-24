import UIKit

struct Country{
    var name: String
    var time: String
}

protocol DataDelegate {
    func addCountry(country: Country)
}

protocol TransferTitleToSelected{
    func transferTitle(title:String)
}

class WorldClock: UITableViewController, DataDelegate{
    
    var delegate: TransferTitleToSelected?
    
    var selectedCountries: [Country] = []
    let CELL_ID = "cellid"
    
    func addCountry(country: Country) {
        selectedCountries.append(country)
        tableView.beginUpdates()
        tableView.insertRows(at: [IndexPath(row: selectedCountries.count-1, section: 0)], with: .automatic)
        tableView.endUpdates()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        styleNavBar()
        configureTableView()
    }
    
    func configureTableView(){
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: CELL_ID)
        tableView.backgroundColor = .black
    }
    
    func styleNavBar(){
        let appearance = UINavigationBarAppearance()
        appearance.largeTitleTextAttributes = [.foregroundColor: UIColor.white]
        appearance.titleTextAttributes = [.foregroundColor: UIColor.white]
        appearance.backgroundColor = .black
        navigationController!.navigationBar.tintColor = .orange
        navigationController!.navigationBar.compactAppearance = appearance
        navigationController!.navigationBar.standardAppearance = appearance
        navigationController!.navigationBar.scrollEdgeAppearance = appearance
        navigationController!.navigationBar.prefersLargeTitles = true
        navigationItem.title = "World Clock"
        navigationItem.rightBarButtonItem = UIBarButtonItem(image: UIImage.init(systemName: "plus"), style: .plain, target: self, action: #selector(goToAdder))
        navigationItem.leftBarButtonItem = editButtonItem
    }
    @objc func goToAdder(){
       let vc = WCCountryAdder()
        vc.delegate = self
        present(UINavigationController(rootViewController:vc), animated: true, completion: nil)
    }
    
    //MARK: DataSource/Delegate
    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return selectedCountries.count
    }
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: CELL_ID, for: indexPath) as! UITableViewCell
        cell.textLabel?.text = selectedCountries[indexPath.row].name
        cell.detailTextLabel?.text = selectedCountries[indexPath.row].time
        return cell
    }
    
    override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        return true
    }
    
    override func tableView(_ tableView: UITableView, canMoveRowAt indexPath: IndexPath) -> Bool {
        return true
    }
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete{
            selectedCountries.remove(at: indexPath.row)
            tableView.beginUpdates()
            tableView.deleteRows(at:[indexPath], with: .automatic)
            tableView.endUpdates()
        }
    }
    override func tableView(_ tableView: UITableView, moveRowAt sourceIndexPath: IndexPath, to destinationIndexPath: IndexPath) {
        let selectedRow = selectedCountries[sourceIndexPath.row]
        selectedCountries.insert(selectedRow, at: destinationIndexPath.row)
        selectedCountries.remove(at: sourceIndexPath.row)
    }
    override func tableView(_ tableView: UITableView, accessoryButtonTappedForRowWith indexPath: IndexPath) {
        print("Button tapped.")
        let vc = selectedCountryVC()
        delegate = vc
        delegate?.transferTitle(title: selectedCountries[indexPath.row].name)
        navigationController!.pushViewController(vc, animated: true)
    }
}
