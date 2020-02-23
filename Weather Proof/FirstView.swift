//
//  FirstView.swift
//  Weather Proof
//
//  Created by Timmy Olsson on 2020-02-08.
//  Copyright © 2020 RiftApps. All rights reserved.
//

import UIKit

class FirstView: ViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        
        let weather = GetWeatherAPI()
        
        weather.getForecast(city: "Stockholm")
        
        print("test")

    }
}
