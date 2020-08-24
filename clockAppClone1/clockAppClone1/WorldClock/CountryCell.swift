//
//  CountryCell.swift
//  clockAppClone1
//
//  Created by Mitchell Park on 2/29/20.
//  Copyright © 2020 Mitchell Park. All rights reserved.
//

import UIKit

class CountryCell: UITableViewCell{
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: .value1, reuseIdentifier: "cellid")
        styleCell()
    }
    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }
    func styleCell(){
        
        textLabel?.textColor = .white
        detailTextLabel?.textColor = .white
        contentView.backgroundColor = .black
        
        showsReorderControl = true
        showsLargeContentViewer = true
        userInteractionEnabledWhileDragging = true
    }
    
    override func setEditing(_ editing: Bool, animated: Bool) {
        if editing == true{
            
        }
    }
}

