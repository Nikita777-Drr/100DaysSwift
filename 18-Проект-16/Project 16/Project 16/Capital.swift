//
//  Capital.swift
//  Project 16
//
//  Created by User on 12.12.2021.
//

import UIKit
import MapKit

class Capital: NSObject, MKAnnotation {
    var title: String?
    var coordinate: CLLocationCoordinate2D
    var info:String
    
    init(title:String, coordinate:CLLocationCoordinate2D, info:String){
        self.title = title
        self.coordinate = coordinate
        self.info = info
    }
}
