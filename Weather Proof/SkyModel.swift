//
//  SkyModel.swift
//  Weather Proof
//
//  Created by Timmy Olsson on 2020-02-17.
//  Copyright © 2020 RiftApps. All rights reserved.
//

import Foundation

struct SkyModel : Codable {
    var id : Int
    var main : String
    var description : String
    var icon : String
}
