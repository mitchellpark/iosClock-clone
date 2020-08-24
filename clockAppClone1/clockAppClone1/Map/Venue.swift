//
//  Venue.swift
//  clockAppClone1
//
//  Created by Mitchell Park on 3/1/20.
//  Copyright © 2020 Mitchell Park. All rights reserved.
//

import MapKit
import AddressBook

class Venue: NSObject, MKAnnotation {
    
    var coordinate: CLLocationCoordinate2D
    var title: String?
    var locationName: String?
    
    init(title:String, locationName: String, coordinate: CLLocationCoordinate2D){
        self.title = title
        self.locationName = locationName
        self.coordinate = coordinate
        super.init()
    }
    var subtitle: String?{
        return locationName
    }
}
