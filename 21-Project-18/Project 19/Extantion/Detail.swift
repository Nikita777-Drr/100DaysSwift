//
//  Detail.swift
//  Extantion
//
//  Created by User on 21.12.2021.
//

import Foundation

class Detail: NSObject, Codable{
    var url = [String]()
    
    init(url:[String]){
        self.url = url
    }
}
