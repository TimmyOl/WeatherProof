//
//  SearchView.swift
//  Weather Proof
//
//  Created by Timmy Olsson on 2020-02-08.
//  Copyright © 2020 RiftApps. All rights reserved.
//

import UIKit

class SearchView: UITableViewController, UISearchBarDelegate{
    @IBOutlet weak var searchBar: UISearchBar!
    
    var allCities = [City]()
    var citySelected = ""
    var filteredCities: [City] = []

    override func viewDidLoad() {
        super.viewDidLoad()
        
        getCities()
        filteredCities = self.allCities
        
        self.tableView.delegate = self
        self.searchBar.delegate = self
        
        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false

        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem
    }
    
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
        if segue.identifier == "cityDetailsSegue",
            let destination: CityDetailsViewViewController = segue.destination as? CityDetailsViewViewController,
            let cityIndex = tableView.indexPathForSelectedRow?.row
        {
            citySelected = filteredCities[cityIndex].name
            destination.city = filteredCities[cityIndex]
            
        }
    }

    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return filteredCities.count
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "reuseIdentifier", for: indexPath)
        
        cell.textLabel?.text = filteredCities[indexPath.row].name

        return cell
    }
    
    func getCities() {
        //parse Cities.json and add names of cities to cities array
        self.allCities = self.readAndDecodeJsonFile(file: "Cities") as! [City]
        
    tableView.reloadData()
    }
    
    func readAndDecodeJsonFile(file: String) -> Any? {
        var cities: [City] = []
        let decoder = JSONDecoder()
        if let path = Bundle.main.path(forResource: file, ofType: "json") {
            do {
                let fileUrl = URL(fileURLWithPath: path)
                //Loading data from file
                let data = try Data(contentsOf: fileUrl, options: .mappedIfSafe)
                
                let cityInfo = try! decoder.decode(CityModel.self, from: data)
                for item in cityInfo.cities {
                    cities.append(item)
                }
            }
            catch {
                print(error)
            }
        }
        return cities
    }
    
    
    /*
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        citySelected = cities[indexPath.row]
    }
    */

    /*
    // Override to support conditional editing of the table view.
    override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the specified item to be editable.
        return true
    }
    */

    /*
    // Override to support editing the table view.
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            // Delete the row from the data source
            tableView.deleteRows(at: [indexPath], with: .fade)
        } else if editingStyle == .insert {
            // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
        }    
    }
    */

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
    // MARK: - SearchBar
    
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        
        let searchText = searchText.lowercased()
        filteredCities = allCities.filter({ $0.name.lowercased().contains(searchText) }) // <<<
        filteredCities = filteredCities.isEmpty ? allCities : filteredCities
        tableView.reloadData()
        
    }
}

