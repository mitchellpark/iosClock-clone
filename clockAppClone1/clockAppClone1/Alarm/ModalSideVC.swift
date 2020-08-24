//
//  ModalSideVC.swift
//  clockAppClone1
//
//  Created by Mitchell Park on 3/15/20.
//  Copyright © 2020 Mitchell Park. All rights reserved.
//

import UIKit

class ModalSideVC: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        setUpButton()
    }
    
    private func setUpButton(){
        let button = UIButton()
        view.addSubview(button)
        button.setTitle("Dismiss", for: .normal)
        button.frame = CGRect(x: view.frame.minX+10, y: view.frame.minY+100, width: 300, height: 100)
        button.addTarget(self, action: #selector(dismissVC), for: .touchUpInside)
    }
    
    @objc
    private func dismissVC(){
        dismiss(animated: true, completion: nil)
    }
    
}
