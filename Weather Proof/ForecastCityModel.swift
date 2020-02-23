//
//  ForecastCityModel.swift
//  Weather Proof
//
//  Created by Timmy Olsson on 2020-02-19.
//  Copyright © 2020 RiftApps. All rights reserved.
//

import Foundation

struct ForecastCityModel : Codable {
    var id : Int
    var name : String
    var coord : ForecastCityCoordinates
}

struct ForecastCityCoordinates : Codable {
    var lon : Double
    var lat : Double
}
