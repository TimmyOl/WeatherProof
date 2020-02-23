//
//  ForecastDataModel.swift
//  Weather Proof
//
//  Created by Timmy Olsson on 2020-02-11.
//  Copyright © 2020 RiftApps. All rights reserved.
//

import Foundation

struct ForecastDataModel : WeatherProtocol, Codable {
    var list : [ForecastDayModel]
    var city : ForecastCityModel
}
