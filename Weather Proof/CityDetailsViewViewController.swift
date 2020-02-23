//
//  CityDetailsViewViewController.swift
//  Weather Proof
//
//  Created by Timmy Olsson on 2020-02-18.
//  Copyright © 2020 RiftApps. All rights reserved.
//

import UIKit
import Foundation

class CityDetailsViewViewController: UIViewController {
    
    // Take in data from SearchView or FavoritesView
    var city = City(id: 2711537, name: "Göteborg", country: "SE", coord: CityCoordinates(lon: 11.97, lat: 57.71))
    
    let appDelegate = UIApplication.shared.delegate as! AppDelegate
    
    let favoriteCitiesKey = "favoriteCities"
    
    var animator: UIDynamicAnimator!
    var gravity: UIDynamicBehavior!
    var collision : UICollisionBehavior!
    
    // TestBox
    var redBoxView: UIView?
    
    @IBOutlet weak var detailsLabelCity: UILabel!
    @IBOutlet weak var detailsLabelWind: UILabel!
    @IBOutlet weak var detailsLabelSky: UILabel!
    @IBOutlet weak var detailsLabelTemp: UILabel!
    @IBOutlet weak var detailsImageWeather: UIImageView!
    @IBOutlet weak var detailsSmallImageWeatherLeft: UIImageView!
    @IBOutlet weak var detailsSmallLabelTimeLeft: UILabel!
    @IBOutlet weak var detailsSmallLabelTempLeft: UILabel!
    @IBOutlet weak var detailsSmallLabelWindLeft: UILabel!
    @IBOutlet weak var detailsSmallImageWeatherMiddle: UIImageView!
    @IBOutlet weak var detailsSmallLabelTimeMiddle: UILabel!
    @IBOutlet weak var detailsSmallLabelTempMiddle: UILabel!
    @IBOutlet weak var detailsSmallLabelWindMiddle: UILabel!
    @IBOutlet weak var detailsSmallImageWeatherRight: UIImageView!
    @IBOutlet weak var detailsSmallLabelTimeRight: UILabel!
    @IBOutlet weak var detailsSmallLabelTempRight: UILabel!
    @IBOutlet weak var detailsSmallLabelWindRight: UILabel!
    @IBOutlet weak var detailsButtonSetHome: UIButton!
    @IBOutlet weak var detailsButtonSetFavorite: UIButton!
    
    let weather = GetWeatherAPI()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        animator = UIDynamicAnimator(referenceView: self.view)
        let imageTap = UILongPressGestureRecognizer(target: self, action: #selector(imageTapped))
        detailsImageWeather.addGestureRecognizer(imageTap)
    }
    
    @objc func imageTapped() {

/*
        var frameRect = CGRect(x: 150, y: 20, width: 60, height: 60)
        redBoxView = UIView(frame: frameRect)
        redBoxView?.backgroundColor = UIColor.red
        self.view.addSubview(redBoxView!)

         //Hittar inte en enda guide på hela internet som inte är reduntant och får massa fel.... är swift communityn efter swift 3 verkligen så liten?? RIKTIGT svårt att hitta guider och information som inte är för gamla...
        let image = detailsImageWeather.image
        gravity = UIGravityBehavior(items: redBoxView!)
         animator.addBehavior(gravity)
         
        collision = UICollisionBehavior (items: redBoxView!)
         collision.translatesReferenceBoundsIntoBoundary = true
         animator.addBehavior(collision)
        
        let behavior = UIDynamicItemBehavior(items: [redBoxView!])
        behavior.elasticity = 2
*/
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        
        self.detailsLabelCity.text = city.name.deParseString(parsedString: city.name)

        weather.getForecast(cityId: city.id) { (Result) in
            switch Result {
            case .success(let weather):
                DispatchQueue.main.async {
                    
                    var temp : Double
                    var wind : Double
                    var sky : String
                    var weatherIcon : String
                    
                    temp = weather.list[0].main["temp"]!
                    wind = weather.list[0].wind.speed
                    sky = weather.list[0].weather[0].main
                    weatherIcon = weather.list[0].weather[0].icon
                                            
                    self.detailsLabelTemp.text = "\(temp)°c"
                    self.detailsLabelWind.text = "\(wind)ms"
                    self.detailsLabelSky.text = "\(sky)"
                    
                    // TODO: Animate background color from temperature
                    
                    //Load and set image/icon
                    var url = URL(string: self.detailsImageWeather.getWeatherIconUrl(icon: weatherIcon))
                    self.detailsImageWeather.downloadImage(from: url!)
                    
                    // Set information in small windows
                    // TODO: make a view/class of a row to create objects instead of the code below...
                    //Column 1: Left
                    let smallWeatherImageLeft = weather.list[1].weather[0].icon
                    url = URL(string: self.detailsImageWeather.getWeatherIconUrl(icon: smallWeatherImageLeft))
                    self.detailsSmallImageWeatherLeft.downloadImage(from: url!)
                    self.detailsSmallLabelTimeLeft.text = "\(self.setTime(rawTime: weather.list[1].dt_txt))"
                    self.detailsSmallLabelTempLeft.text = "\(weather.list[1].main["temp"]!)°c"
                    self.detailsSmallLabelWindLeft.text = "\(weather.list[1].wind.speed)ms"
                    
                    //Column 2: Middle
                    let smallWeatherImageMiddle = weather.list[2].weather[0].icon
                    url = URL(string: self.detailsImageWeather.getWeatherIconUrl(icon: smallWeatherImageMiddle))
                    self.detailsSmallImageWeatherMiddle.downloadImage(from: url!)
                    self.detailsSmallLabelTimeMiddle.text = "\(self.setTime(rawTime: weather.list[2].dt_txt))"
                    self.detailsSmallLabelTempMiddle.text = "\(weather.list[2].main["temp"]!)°c"
                    self.detailsSmallLabelWindMiddle.text = "\(weather.list[2].wind.speed)ms"
                    
                    //Column 3: Right
                    let smallWeatherImageRight = weather.list[3].weather[0].icon
                    url = URL(string: self.detailsImageWeather.getWeatherIconUrl(icon: smallWeatherImageRight))
                    self.detailsSmallImageWeatherRight.downloadImage(from: url!)
                    self.detailsSmallLabelTimeRight.text = "\(self.setTime(rawTime: weather.list[3].dt_txt))"
                    self.detailsSmallLabelTempRight.text = "\(weather.list[3].main["temp"]!)°c"
                    self.detailsSmallLabelWindRight.text = "\(weather.list[3].wind.speed)ms"
                    
                }
            case .failure(let error): print("Error \(error)")
            }
        }
        
        if checkIfFavorite() {
            detailsButtonSetFavorite.setTitle("Remove Favorite", for: UIControl.State.normal)
            detailsButtonSetFavorite.backgroundColor = UIColor.red
        }
    }
    
    func setTime(rawTime: String) -> String {
        let tempTimeStart = rawTime.index(rawTime.startIndex, offsetBy: 10)
        let tempTimeEnd = rawTime.index(rawTime.endIndex, offsetBy: -3)
        let tempTimeRange = tempTimeStart..<tempTimeEnd
        let tempSubstring = rawTime[tempTimeRange]
        let tempTimeFormatted = String(tempSubstring)
        return tempTimeFormatted
    }

    @IBAction func setAsHome(_ sender: Any) {
        let defaults = UserDefaults.standard
        
        let cityIdKey = "cityId"
        
        defaults.set(city.id, forKey: cityIdKey)
    }
    
    @IBAction func setAsFavorite(_ sender: Any) {
        if let title = detailsButtonSetFavorite.title(for: UIControl.State.normal) {
            if title == "Add to Favorites" {
                toggleFavoriteCity(addCity: true)
                detailsButtonSetFavorite.setTitle("Remove Favorite", for: UIControl.State.normal)
                detailsButtonSetFavorite.backgroundColor = UIColor.red
            }
            else {
                toggleFavoriteCity(addCity: false)
                detailsButtonSetFavorite.setTitle("Add to Favorites", for: UIControl.State.normal)
                detailsButtonSetFavorite.backgroundColor = UIColor.systemYellow
                detailsButtonSetFavorite.alpha = 0.85
            }
        }
        NotificationCenter.default.post(name: Notification.Name(rawValue: "disconnectPaxiSockets"), object: nil)
    }
    
    func toggleFavoriteCity(addCity: Bool) {
        
        var favoriteCities: [City] = []
        
        favoriteCities = readFavoriteArray()
            
            if addCity {
                favoriteCities.append(city)
            }
            else {
                // Find and remove city in array
                if let index = favoriteCities.firstIndex(where: { $0.id == city.id }) {
                    favoriteCities.remove(at: index)
                }
            }
        encodeAndSaveToUserDefaults(cities: favoriteCities, key: favoriteCitiesKey)
    }

    func readFavoriteArray() -> [City] {
        var allCities: [City] = []
        if UserDefaults.exists(key: favoriteCitiesKey) {
            //Decode json data from userdefaults to new array
            var getAllCities: [City] {
                let defaultObject = self.city
                if let cities = UserDefaults.standard.value(forKey: favoriteCitiesKey) as? Data {
                    let decoder = JSONDecoder()
                    if let citiesDecoded = try? decoder.decode(Array.self, from: cities) as [City] {
                        return citiesDecoded
                    }
                    else {
                        return [defaultObject]
                    }
                }
                else {
                    return [defaultObject]
                }
            }
            allCities = getAllCities
        }

        return allCities
    }
    
    func checkIfFavorite() -> Bool{
        let tempFavoritesArray = self.readFavoriteArray()
        
        return tempFavoritesArray.contains(where: { $0.name == self.city.name })
    }
    
    func encodeAndSaveToUserDefaults(cities: [City], key: String) {
         let encoder = JSONEncoder()
         if let encodedCities = try? encoder.encode(cities){
            UserDefaults.standard.set(encodedCities, forKey: key)
         }
    }
    
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */
}
