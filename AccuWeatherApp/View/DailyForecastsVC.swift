//
//  ViewController.swift
//  AccuWeatherApp
//
//  Created by FS K on 27.01.2023.
//
import UIKit
import Foundation


class DailyForecastsVC: UIViewController{
    
    @IBOutlet weak var tableViewWeatherPageVC: UITableView!
    @IBOutlet weak var labelCity: UILabel!
    @IBOutlet weak var labelCurrentDate: UILabel!
    @IBOutlet weak var textViewRegion: UITextView!
    @IBOutlet weak var imageViewCurrentDayIcon: UIImageView!
    @IBOutlet weak var labelCurrentDayWeatherDegree: UILabel!
    @IBOutlet weak var labelCurrentDayWeatherExplain: UILabel!
    @IBOutlet weak var imageViewCurrentNightIcon: UIImageView!
    @IBOutlet weak var labelCurrentNightWeatherDegree: UILabel!
    @IBOutlet weak var labelCurrentNightWeatherExplain: UILabel!
    @IBOutlet weak var weatherUIView: UIView!
    @IBOutlet weak var imageViewSearchCity: UIImageView!
    
    
    let apiKey = "K7E21UOiKzytem9HA595i9f5MzXjXB5d"
    
    var chosenCityId:Int = 1
    var chosenCityName = ""
    var chosenRegionName = ""
    var chosenCityArr:[String] = []
    
    private var cityWeatherViewModel : CityWeatherViewModel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableViewWeatherPageVC.delegate = self
        tableViewWeatherPageVC.dataSource = self
        tableViewWeatherPageVC.layer.cornerRadius = 28
        weatherUIView.layer.cornerRadius = 28

        motionDetector()
       
        getData()
    }
    
    
    func motionDetector() {
        
        imageViewSearchCity.isUserInteractionEnabled = true
        let tapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(searchCity))
        imageViewSearchCity.addGestureRecognizer(tapGestureRecognizer)
        
    }
    
    
    @objc func searchCity() {
        performSegue(withIdentifier: "toSearchCitiesVC", sender: nil)
    }
    
    
    func getData() {
        
        if chosenCityId != 0{
            
            if let url = URL(string: "https://dataservice.accuweather.com/forecasts/v1/daily/5day/\(chosenCityId)?apikey=\(apiKey)&details=false&metric=true"){
                
                WebserviceCityWeather().downloadCityDailyForecasts(url: url) { cityWeathers in
                 
                    if let safeCityWeathers = cityWeathers {
                        
                        self.cityWeatherViewModel = CityWeatherViewModel(cityWeather: safeCityWeathers)
                        
                        DispatchQueue.main.async {
                            self.tableViewWeatherPageVC.reloadData()
                        }
                    }
                }
            }
        }
        else  {
            DispatchQueue.main.async {
                self.tableViewWeatherPageVC.reloadData()
            }
        }
    }
    
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        if segue.identifier == "toSearchCitiesVC" {
        
            let destinationVC = segue.destination as! SearchCitiesVC
            
            destinationVC.selectedCityId = String(self.chosenCityId)
            destinationVC.selectedCityName = self.chosenCityName
            destinationVC.selectedRegionName = self.chosenRegionName
            
            print(destinationVC.selectedCityId)
            print(destinationVC.selectedCityName)
            print(destinationVC.selectedRegionName)
            
            
        }
    }
    
    
    func makeAlert(titleInput: String, messageInput: String) {
        let alert = UIAlertController(title: titleInput, message: messageInput, preferredStyle: UIAlertController.Style.alert)
        let okButton = UIAlertAction(title: "OK", style: UIAlertAction.Style.default, handler: nil)
        alert.addAction(okButton)
        self.present(alert, animated: true)
    }
    
    
    func getFormattedDate(isoDate: String) -> String {
        
        let inDateFormatter = ISO8601DateFormatter()
        let df = DateFormatter()
        
        df.dateFormat = "d MMMM EEEE"
        df.locale = Locale(identifier: "tr")
            
        let date = inDateFormatter.date(from: isoDate)
        let formattedString = df.string(from: date!)
        
        return formattedString
        
    }
}


extension DailyForecastsVC: UITableViewDataSource,UITableViewDelegate {
    
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
               
        let cell = tableViewWeatherPageVC.dequeueReusableCell(withIdentifier: "WeatherCell") as! WeatherTableViewCell
        let whichDay = indexPath.row
           
        if self.cityWeatherViewModel != nil {
    
            if whichDay == 0 {
                
                let dateString = self.cityWeatherViewModel.weatherDate(whichDay)
                self.labelCurrentDate.text = getFormattedDate(isoDate: dateString)
               
                if chosenRegionName != "" {
                    chosenCityArr = chosenRegionName.components(separatedBy: ",")
                    
                    if chosenCityName.caseInsensitiveCompare(chosenCityArr[0]) == .orderedSame {
                        self.textViewRegion.text = chosenCityArr[1]
                    }
                    else if chosenCityName.caseInsensitiveCompare(chosenCityArr[0]) != .orderedSame{
                        self.textViewRegion.text = self.chosenRegionName
                    }
                }
                
                self.labelCity.text = self.chosenCityName
                self.labelCurrentDayWeatherDegree.text = self.cityWeatherViewModel.weatherDayTemperature(whichDay)
                self.labelCurrentDayWeatherExplain.text = self.cityWeatherViewModel.weatherDayIconPhrase(whichDay)
                self.labelCurrentNightWeatherDegree.text = self.cityWeatherViewModel.weatherNightTemperature(whichDay)
                self.labelCurrentNightWeatherExplain.text = self.cityWeatherViewModel.weatherNightIconPhrase(whichDay)
                self.imageViewCurrentDayIcon.image = UIImage(named: "AirConditionIcons/\(self.cityWeatherViewModel.weatherDayIcon(whichDay))")
                self.imageViewCurrentNightIcon.image = UIImage(named: "AirConditionIcons/\(self.cityWeatherViewModel.weatherNightIcon(whichDay))")
                

            }
            
            let dateString = self.cityWeatherViewModel.weatherDate(whichDay+1)
            cell.dateLabel.text = getFormattedDate(isoDate: dateString)
            cell.dayHeatLabel.text = self.cityWeatherViewModel.weatherDayTemperature(whichDay+1)
            cell.dayAirConditionLabel.text = self.cityWeatherViewModel.weatherDayIconPhrase(whichDay+1)
            cell.nightHeatLabel.text = self.cityWeatherViewModel.weatherNightTemperature(whichDay+1)
            cell.nightAirConditionLabel.text = self.cityWeatherViewModel.weatherNightIconPhrase(whichDay+1)
            cell.dayImageView.image = UIImage(named: "AirConditionIcons/\(self.cityWeatherViewModel.weatherDayIcon(whichDay+1))")
            cell.nightImageView.image = UIImage(named: "AirConditionIcons/\(self.cityWeatherViewModel.weatherNightIcon(whichDay+1))")
            
        }
        return cell
    }
    
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 4
    }
    
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        print("Selected")
    }
    
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 107
    }
}



