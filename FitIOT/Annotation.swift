//
//  Annotation.swift
//  FitIOT
//
//  Created by sanou abou on 22/10/2019.
//  Copyright © 2019 sanou abou. All rights reserved.
//
import Foundation
import MapKit


class Annotation: NSObject, MKAnnotation {
    let title: String?
    let locationName: String
    let coordinate: CLLocationCoordinate2D
    
    init(title: String, locationName: String, coordinate: CLLocationCoordinate2D) {
        self.title = title
        self.locationName = locationName
        self.coordinate = coordinate
        
        super.init()
    }
}
