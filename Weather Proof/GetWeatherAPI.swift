//
//  GetWeatherAPI.swift
//  Weather Proof
//
//  Created by Timmy Olsson on 2020-02-07.
//  Copyright © 2020 RiftApps. All rights reserved.
//

import Foundation

class GetWeatherAPI {
    
    /*
     Types of data / Strings to pass in type when calling getForecast Default = "Weather"
     "weather"
     "forecast"
     */
    
    //Default Dictionary Keys
    let cityIdKey = "cityId"
    let cityKey = "city"
    let tempKey = "temp"
    let windKey = "wind"
    let skyKey = "sky"
    let iconCode = "iconCode"
    
    private let openWeatherURL = "https://openweathermap.org/data/2.5/"
    private let apiKey = "b6907d289e10d714a6e88b30761fae22"
    
    let defaults = UserDefaults.standard
    
    // Function to connect and retrieve data, call with home: true to set as home
    func getWeather(cityId : Int, home: Bool = false, completion: @escaping( Result<WeatherDataModel, Error> ) -> Void) {
        let session = URLSession.shared
        let type = "weather"
        let forecastURL = URL(string: "\(openWeatherURL)\(type)?id=\(cityId)&appid=\(apiKey)")!
        let forecastURLRequest = URLRequest(url: forecastURL)
        
        let task = session.dataTask(with: forecastURLRequest as URLRequest) {
            (data: Data?, response: URLResponse?, error: Error?) in
            if let error = error {
                print("Error: \(error)")
                completion(.failure(error))
            }
            else {
                let apiAnswer: WeatherDataModel = self.parseANDDecodeJSONData(data: data!, type: type) as! WeatherDataModel
                completion(.success(apiAnswer))
            }
        }
        task.resume()
    }
    
    func getForecast(cityId : Int, completion: @escaping( Result<ForecastDataModel, Error> ) -> Void) {
         let session = URLSession.shared
         let type = "forecast"
         let forecastURL = URL(string: "\(openWeatherURL)\(type)?id=\(cityId)&appid=\(apiKey)")!
         let forecastURLRequest = URLRequest(url: forecastURL)
         
         let task = session.dataTask(with: forecastURLRequest as URLRequest) {
             (data: Data?, response: URLResponse?, error: Error?) in
             if let error = error {
                 print("Error: \(error)")
                 completion(.failure(error))
             }
             else {
                 let apiAnswer: ForecastDataModel = self.parseANDDecodeJSONData(data: data!, type: type) as! ForecastDataModel
                 completion(.success(apiAnswer))
             }
         }
         task.resume()
     }
    
    func parseANDDecodeJSONData(data: Data, type: String) -> Any {
        let decoder = JSONDecoder()
        do {
            switch type {
            case "weather":
                let apiAnswer = try! decoder.decode(WeatherDataModel.self, from: data)
                
                return apiAnswer
                
            case "forecast":
                let apiAnswer = try! decoder.decode(ForecastDataModel.self, from: data)
                
                return apiAnswer
                
            default:
                print("Error in decode")
                
                let apiAnswer = try! decoder.decode(WeatherDataModel.self, from: data)
                
                return apiAnswer
            }
        }
    }
}
