//
//  HomeView.swift
//  Weather Proof
//
//  Created by Timmy Olsson on 2020-02-08.
//  Copyright © 2020 RiftApps. All rights reserved.
//

import UIKit

class HomeView: ViewController {
    
    //Default Dictionary Keys
    let cityIdKey = "cityId"
    
    @IBOutlet weak var labelCity: UILabel!
    @IBOutlet weak var labelTemp: UILabel!
    @IBOutlet weak var labelWind: UILabel!
    @IBOutlet weak var labelSky: UILabel!
    @IBOutlet weak var imageBG: UIImageView!
    @IBOutlet weak var imageWeather: UIImageView!
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        
        let homeCity = checkAndLoadCity(cityIdKey: cityIdKey)
        let weather = GetWeatherAPI()
        
        weather.getWeather(cityId: homeCity) { (Result) in
            switch Result {
            case .success(let weather):
                DispatchQueue.main.async {

                    let name = weather.name
                    let temp = weather.main["temp"]!
                    let wind = weather.wind.speed
                    let sky = weather.weather[0].main
                    let bg = String(weather.weather[0].icon.suffix(1))
                    let weatherIcon = weather.weather[0].icon
                    
                    self.labelCity.text = name
                    self.labelTemp.text = "\(temp)°c"
                    self.labelWind.text = "\(wind)ms"
                    self.labelSky.text = "\(sky)"
                    setBackground(dayOrNight: bg, imageView: self.imageBG)
                    
                    //Load and set image/icon
                    let url = URL(string: self.imageWeather.getWeatherIconUrl(icon: weatherIcon))
                    self.imageWeather.downloadImage(from: url!)
                }
            case .failure(let error):
                print("Error \(error)")
            }
        }
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(true)
        
        animateWeatherIcon(imageView: imageWeather, view: view)
        
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
    }
}

func animateWeatherIcon(imageView: UIImageView, view: UIView) {
    UIView.animate(withDuration: 2, delay: 0,
        options: [.autoreverse, .repeat],
        animations: {
            imageView.transform = CGAffineTransform(scaleX: 1.3, y: 1.3)
            view.layoutIfNeeded()
        	},
        completion: nil)
}

func checkAndLoadCity(cityIdKey: String) -> Int {
    let defaults = UserDefaults.standard
    
    //Set default city of no Home is set
    if !UserDefaults.exists(key: cityIdKey) {
        defaults.set(2711537, forKey: cityIdKey)
    }

    let defaultCity = defaults.integer(forKey: cityIdKey)
        
    return defaultCity
}

func setBackground(dayOrNight: String, imageView: UIImageView) {
    if dayOrNight == "d" {
        imageView.image = UIImage(named: "bg_day")
        imageView.alpha = 0.8
    }
    else {
        imageView.image = UIImage(named: "bg_night")
        imageView.alpha = 0.5
    }
}

// MARK: Check if userDefault exist extension

extension UserDefaults {

    static func exists(key: String) -> Bool {
        return UserDefaults.standard.object(forKey: key) != nil
    }

}

// MARK: Set Image Extension

// Extension to download an image from url and set to imageView
extension UIImageView {
    func getData(from url: URL, completion: @escaping (Data?, URLResponse?, Error?) -> ()) {
        URLSession.shared.dataTask(with: url, completionHandler: completion).resume()
    }
    func downloadImage(from url: URL) {
        getData(from: url) { data, response, error in guard let data = data, error == nil else { return }
            DispatchQueue.main.async() {
                self.image = UIImage(data: data)
            }
        }
    }
    func getWeatherIconUrl(icon: String) -> String {
        let iconUrl = "http://openweathermap.org/img/wn/\(icon)@2x.png"
        
        return iconUrl
    }
}

// MARK: String parse åäö Extension

extension String {
    func parseString(rawString: String, stringOfCharsToParse: String) -> String{
        let charSet = CharacterSet(charactersIn: stringOfCharsToParse)
        var parsedString = rawString
        if let _ = rawString.rangeOfCharacter(from: charSet, options: .caseInsensitive) {
            if rawString.lowercased().contains("å") {
                parsedString = rawString.replacingOccurrences(of: "å", with: "%E5")
            }
            if rawString.lowercased().contains("ä") {
                parsedString = rawString.replacingOccurrences(of: "ä", with: "%E4")
            }
            if rawString.lowercased().contains("ö") {
                parsedString = rawString.replacingOccurrences(of: "ö", with: "%F6")
            }
        }
        return parsedString
    }
    func deParseString(parsedString: String) -> String{
        var deParsedString = parsedString
            if parsedString.contains("%E5") {
                deParsedString = parsedString.replacingOccurrences(of: "%E5", with: "å")
            }
            if parsedString.contains("%E4") {
                deParsedString = parsedString.replacingOccurrences(of: "%E4", with: "ä")
            }
            if parsedString.contains("%F6") {
                deParsedString = parsedString.replacingOccurrences(of: "%F6", with: "ö")
            }
        return deParsedString
    }
}
