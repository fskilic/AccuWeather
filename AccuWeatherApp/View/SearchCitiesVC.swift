//
//  SearchCities.swift
//  AccuWeatherApp
//
//  Created by FS K on 27.01.2023.
//


import UIKit
import CoreLocation


class SearchCitiesVC: UIViewController{
    
    @IBOutlet weak var backButtonIV: UIImageView!
    @IBOutlet weak var searchCityTF: UITextField!
    @IBOutlet weak var cityTV: UITableView!
    @IBOutlet weak var currentLocationIV: UIImageView!
    
    let apiKey = "K7E21UOiKzytem9HA595i9f5MzXjXB5d"
    var numOfRow : Int = 0
    
    var locationManager = CLLocationManager()
    var latitude : Double = 0.0
    var longitude : Double = 0.0
    
    var cityArr : [String] = []
    var city = ""
    var cArr: [String] = []
    var cId = ""
    var cName = ""
    var cRegion = ""
    
    var selectedCityId = ""
    var selectedCityName = ""
    var selectedAdministrativeArea = ""
    var selectedRegionName = ""
    var saveRegion = ""
    
    var  userDefaults = UserDefaults.standard
    
    private var currentCityViewModel : SearchCityViewModel!
    private var searchCityListViewModel : SearchCityListViewModel!
    
    
    @IBAction func textFieldChanged(_ sender: UITextField) {
        
        let search = sender.text ?? ""
        filterContentForSearchText(search)
        
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        cityTV.delegate = self
        cityTV.dataSource = self
        cityTV.rowHeight = 75

        motionDetector()
        getUserDefaults()
    }

    
    func motionDetector() {
        
        backButtonIV.isUserInteractionEnabled = true
        let tapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(backButtonClicked))
        backButtonIV.addGestureRecognizer(tapGestureRecognizer)
        
        currentLocationIV.isUserInteractionEnabled = true
        let gestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(currentLocationClicked))
        currentLocationIV.addGestureRecognizer(gestureRecognizer)
        
    }
    
    
    @objc func currentLocationClicked() {
        locationManager.delegate = self
      
        
        currentLocation()
    }
    
    
    @objc func backButtonClicked() {
        if selectedCityId != "" && selectedCityName != "" && selectedRegionName != "" {
            performSegue(withIdentifier: "toDailyForecastsVC", sender: nil)
        }
    }
    

    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        if segue.identifier == "toDailyForecastsVC" {
    
            let destinationVC = segue.destination as! DailyForecastsVC
            if selectedCityId != "" && selectedCityName != "" && selectedRegionName != "" {
                destinationVC.chosenCityId = Int(selectedCityId) ?? 1
                destinationVC.chosenCityName = selectedCityName
                destinationVC.chosenRegionName = selectedRegionName
            }
        }
    }
   
    
    func filterContentForSearchText(_ searchText: String) {
       
        let city = searchText
        
        if city != ""{
            
            if let url = URL(string: "https://dataservice.accuweather.com/locations/v1/cities/autocomplete?apikey=\(apiKey)&q=\(city)") {
                
                WebserviceSearchCity().downloadCities(url: url) { (cities) in
                    if let cities = cities {
                        
                        self.searchCityListViewModel = SearchCityListViewModel(searchCityList: cities)
                        
                        DispatchQueue.main.async {
                            self.getUserDefaults()
                            self.cityTV.reloadData()
                        }
                    }
                }
            }
            
        }
        else if city == ""{
            
            self.searchCityListViewModel = SearchCityListViewModel(searchCityList: [])
           
            DispatchQueue.main.async {
                self.getUserDefaults()
                self.cityTV.reloadData()
            }
        }
    }
    
    func makeAlert(titleInput: String, messageInput: String) {
        let alert = UIAlertController(title: titleInput, message: messageInput, preferredStyle: UIAlertController.Style.alert)
        let okButton = UIAlertAction(title: "OK", style: UIAlertAction.Style.default, handler: nil)
        alert.addAction(okButton)
        self.present(alert, animated: true)
    }
}


extension SearchCitiesVC{
    
    func setUserDefaults(city: String) {
        
        cityArr = cityArr.filter{$0 != city }
        cityArr.insert(city, at: 0)
        userDefaults.set(cityArr, forKey: "Cities")
        
    }
    
    
    func getUserDefaults(){
        if userDefaults.array(forKey: "Cities") != nil {
            cityArr = userDefaults.array(forKey: "Cities") as! [String]
        }
    }
}


extension SearchCitiesVC: UITableViewDelegate, UITableViewDataSource {
    
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        
        if  cityArr.count < 5 {
            numOfRow = cityArr.count
        }
        else {
            numOfRow = 5
        }
        return searchCityListViewModel != nil && !searchCityListViewModel.searchCityList.isEmpty ? searchCityListViewModel.numberOfRowsInSection() : numOfRow
        
    }
    
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = cityTV.dequeueReusableCell(withIdentifier: "searchCities") as! SearchTableViewCell
        
        if searchCityListViewModel != nil && !searchCityListViewModel.searchCityList.isEmpty{
            
            let searchCityViewModel = self.searchCityListViewModel.cityAtIndex(indexPath.row)
            cell.cityL.text = searchCityViewModel.cityName
            cell.regionL.text = searchCityViewModel.regionName
            
        }
        else if !cityArr.isEmpty {
            
            if let cityArr = userDefaults.array(forKey: "Cities") as? [String]{
                
                cArr = cityArr[indexPath.row].components(separatedBy: ".")
                cId = cArr[0]
                cName = cArr[1]
                cRegion = cArr[2]
                cell.cityL.text = cName
                cell.regionL.text = cRegion
                
            }
        }
        return cell
    }
    
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        if self.searchCityListViewModel != nil && !searchCityListViewModel.searchCityList.isEmpty {
            
            selectedCityId = self.searchCityListViewModel.cityAtIndex(indexPath.row).cityId
            selectedCityName = self.searchCityListViewModel.cityAtIndex(indexPath.row).cityName
            selectedRegionName = self.searchCityListViewModel.cityAtIndex(indexPath.row).regionName
            
            self.saveRegion = "\(self.selectedCityId).\(self.selectedCityName).\(self.selectedRegionName)"
            self.setUserDefaults(city: self.saveRegion)
                
            
        }
        else {
            
            if let cityArr = userDefaults.array(forKey: "Cities") as? [String]{
                
                cArr = cityArr[indexPath.row].components(separatedBy: ".")
                cId = cArr[0]
                cName = cArr[1]
                cRegion = cArr[2]
                selectedCityId = cId
                selectedCityName = cName
                selectedRegionName = cRegion
                
                self.saveRegion = "\(self.selectedCityId).\(self.selectedCityName).\(self.selectedRegionName)"
                self.setUserDefaults(city: self.saveRegion)
                
            }
        }
        if selectedCityId != "" {
            performSegue(withIdentifier: "toDailyForecastsVC", sender: nil)
        }
    }
    
}


extension SearchCitiesVC: CLLocationManagerDelegate {
   
    
    func currentLocation() {
        locationManager.desiredAccuracy = kCLLocationAccuracyKilometer
        //locationManager.requestWhenInUseAuthorization()
        locationManager.requestAlwaysAuthorization()
        locationManager.startUpdatingLocation()
    
     }
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        
        latitude = locations[0].coordinate.latitude
        longitude = locations[0].coordinate.longitude
        
        if let url = URL(string: "https://dataservice.accuweather.com/locations/v1/cities/geoposition/search?apikey=\(self.apiKey)&q=\(self.latitude)%2C\(self.longitude)&details=true") {
            print(url)
            WebserviceSearchCity().downloadCurrentLocation(url: url) { (city) in
               
                if let city = city {
                    
                    self.currentCityViewModel = SearchCityViewModel(searchCity: city)
                    
                    self.selectedCityId = self.currentCityViewModel.cityId
                    self.selectedCityName = self.currentCityViewModel.cityName
                    self.selectedRegionName = self.currentCityViewModel.regionName
                    
                    self.saveRegion = "\(self.selectedCityId).\(self.selectedCityName).\(self.selectedRegionName)"
                    self.setUserDefaults(city: self.saveRegion)
                    print(self.selectedCityId)
                    print(self.selectedCityName)
                    print(self.selectedRegionName)
                    DispatchQueue.main.async {
                        self.performSegue(withIdentifier: "toDailyForecastsVC", sender: nil)
                    }
                }
            }
        }
        
    }
}

