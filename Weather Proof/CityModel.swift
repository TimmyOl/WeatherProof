//
//  CityModel.swift
//  Weather Proof
//
//  Created by Timmy Olsson on 2020-02-18.
//  Copyright © 2020 RiftApps. All rights reserved.
//

import Foundation

struct CityModel : Codable {
    var cities : [City]
}

struct City : Codable {
    var id : Int
    var name : String
    var country : String
    var coord : CityCoordinates
}

struct CityCoordinates : Codable {
    var lon : Double
    var lat : Double
}


