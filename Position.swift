//
//  Position.swift
//  FitIOT
//
//  Created by abou on 06/11/2019.
//  Copyright © 2019 sanou abou. All rights reserved.
//

import Foundation

class Position {
    
    var id: Int!
    var latitude: String!
    var longitude: String!
    
    
    init(latitude: String, longitude: String) {
        self.latitude = latitude
        self.longitude = longitude
    }
    
    init(id: Int, latitude: String, longitude: String) {
        self.id = id
        self.latitude = latitude
        self.longitude = longitude
    }
    
    
}
