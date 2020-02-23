//
//  ForecastDayModel.swift
//  Weather Proof
//
//  Created by Timmy Olsson on 2020-02-19.
//  Copyright © 2020 RiftApps. All rights reserved.
//

import Foundation

struct ForecastDayModel : Codable {
    var main : Dictionary<String, Double>
    var wind : WindModel
    var weather : [SkyModel]
    var dt_txt : String
}
