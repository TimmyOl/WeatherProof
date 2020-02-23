//
//  WeatherDataModel.swift
//  Weather Proof
//
//  Created by Timmy Olsson on 2020-02-10.
//  Copyright © 2020 RiftApps. All rights reserved.
//

import Foundation

struct WeatherDataModel : WeatherProtocol, Codable {
    var id : Int
    var name : String
    var main : Dictionary<String, Double>
    var wind : WindModel
    var weather : [SkyModel]
}
