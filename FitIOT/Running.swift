//
//  Running.swift
//  FitIOT
//
//  Created by sanou abou on 05/11/2019.
//  Copyright © 2019 sanou abou. All rights reserved.
//

import Foundation

class Running {
    
    var id: Int!
    var time: String!
    var distance: String!
    var dateTime: String!
    
    init(time: String, distance: String) {
        self.time = time
        self.distance = distance
    }
    
    init(id: Int,time: String, distance: String) {
        self.id = id
        self.time = time
        self.distance = distance
    }
    
    init(id: Int,time: String, distance: String,dateTime: String) {
        self.id = id
        self.dateTime = dateTime
        self.time = time
        self.distance = distance
    }
    
}
