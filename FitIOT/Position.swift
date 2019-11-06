//
//  Position.swift
//  FitIOT
//
//  Created by sanou abou on 05/11/2019.
//  Copyright © 2019 sanou abou. All rights reserved.
//

import Foundation
class Position {
   
    var latitude: String
    var longitude: String
    var idRunning: Int
    init(idRunning: Int, longitude: String, latitude: String) {
        self.idRunning = idRunning
        self.longitude = longitude
        self.latitude = latitude
    }
}
