//
//  Person.swift
//  Project 10-12
//
//  Created by User on 02.12.2021.
//

import UIKit

class Person: Codable {
    var name:String
    var image:String
    
    init(name:String, image:String){
        self.name = name
        self.image = image
    }
}
