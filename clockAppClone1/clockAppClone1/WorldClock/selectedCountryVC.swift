//
//  selectedCountryVC.swift
//  clockAppClone1
//
//  Created by Mitchell Park on 3/1/20.
//  Copyright © 2020 Mitchell Park. All rights reserved.
//

import UIKit

class selectedCountryVC: UIViewController, TransferTitleToSelected {
    
    func transferTitle(title: String) {
        navigationItem.title = title
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        styleNavBar()
        
    }
    
    func styleNavBar(){
        navigationItem.rightBarButtonItem = UIBarButtonItem(image: UIImage.init(systemName: "plus"), style: .plain, target: self, action: #selector(showOptions))
    }
    
    @objc func showOptions(){
        let alertController = UIAlertController(title: "Action needed.", message: "Pick the background color that best suits your moon.", preferredStyle: .actionSheet)
        alertController.addAction(UIAlertAction(title: "Green", style: .default, handler: greenBackground))
        alertController.addAction(UIAlertAction(title: "Yellow", style: .default, handler: yellowBackground))
        alertController.addAction(UIAlertAction(title: "Pink", style: .default, handler: pinkBackground))
        alertController.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: nil))
        present(alertController, animated: true, completion: nil)
    }
    func greenBackground(a: UIAlertAction){
        view.backgroundColor = .green
    }
    func yellowBackground(a: UIAlertAction){
        view.backgroundColor = .yellow
    }
    func pinkBackground(a: UIAlertAction){
        view.backgroundColor = .systemPink
    }
}
