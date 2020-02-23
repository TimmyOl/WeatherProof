//
//  FavoritesView.swift
//  Weather Proof
//
//  Created by Timmy Olsson on 2020-02-08.
//  Copyright © 2020 RiftApps. All rights reserved.
//

import UIKit

class FavoritesView: UITableViewController, ReloadTableViewProtocol {
    
    var favoriteCities: [City] = []
    var defaultCity = City(id: 1, name: "Error", country: "SE", coord: CityCoordinates(lon: 11.97, lat: 57.71))
    let favoriteCitiesKey = "favoriteCities"

    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewDidAppear(true)
        updateTableView()
        NotificationCenter.default.addObserver(self, selector: #selector(disconnectPaxiSocket(_:)), name: Notification.Name(rawValue: "disconnectPaxiSockets"), object: nil)
    }
    
    // Object run from notification coming from CityDetailsViewViewController
    @objc func disconnectPaxiSocket(_ notification: Notification) {
        updateTableView()
    }
    
    func getCitiesFromUserDefaults() -> [City] {
        if UserDefaults.exists(key: self.favoriteCitiesKey) {
            //Decode json data from userdefaults to new favoriteCitities array
            var getAllCities: [City] {
                if let cities = UserDefaults.standard.value(forKey: favoriteCitiesKey) as? Data {
                    let decoder = JSONDecoder()
                    if let citiesDecoded = try? decoder.decode(Array.self, from: cities) as [City] {
                        return citiesDecoded
                    }
                    else {
                        return []
                    }
                }
                else {
                    return []
                }
            }
            return getAllCities
        }
        else {
            return []
        }
    }

    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return favoriteCities.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "tableFavoriteCell", for: indexPath)
    
        cell.textLabel?.text = favoriteCities[indexPath.row].name

        return cell
    }
    
    // Update list and reload tableView
    public func updateTableView() {
        favoriteCities = getCitiesFromUserDefaults()
        tableView.reloadData()
    }

    /*
    // Override to support conditional editing of the table view.
    override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the specified item to be editable.
        return true
    }
    */


    // Override to support editing the table view.
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            // Delete the row from the data source
            favoriteCities.remove(at: indexPath.row)
            tableView.deleteRows(at: [indexPath], with: .fade)
            encodeAndSaveToUserDefaults(cities: favoriteCities, key: favoriteCitiesKey)
        } else if editingStyle == .insert {
            // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
            //Leaving this here for future functions
        }    
    }
    
    func encodeAndSaveToUserDefaults(cities: [City], key: String) {
         let encoder = JSONEncoder()
         if let encodedCities = try? encoder.encode(cities){
            UserDefaults.standard.set(encodedCities, forKey: key)
         }
    }

    /*
    // Override to support rearranging the table view.
    override func tableView(_ tableView: UITableView, moveRowAt fromIndexPath: IndexPath, to: IndexPath) {

    }
    */

    /*
    // Override to support conditional rearranging of the table view.
    override func tableView(_ tableView: UITableView, canMoveRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the item to be re-orderable.
        return true
    }
    */

    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
        if segue.identifier == "cityDetailsSegue",
            let destination: CityDetailsViewViewController = segue.destination as? CityDetailsViewViewController,
            let cityIndex = tableView.indexPathForSelectedRow?.row
        {
            destination.city = favoriteCities[cityIndex]
        }
    }

}
