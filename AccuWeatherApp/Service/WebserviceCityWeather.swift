//
//  WebserviceCityWeather.swift
//  AccuWeatherApp
//
//  Created by FS K on 29.01.2023.
//

import Foundation

class WebserviceCityWeather {
    
    func downloadCityDailyForecasts(url: URL, completion: @escaping (CityWeather?) -> ()) {
        
        URLSession.shared.dataTask(with: url) { data, response, error in
            
            if let error = error {
                
                print(error.localizedDescription)
                completion(nil)

            }
            else if let safeData = data {
                
                let cityList = try? JSONDecoder().decode(CityWeather.self, from: safeData)
                
                if let cityList = cityList {
                    completion(cityList)
                }
            }
        }.resume()
    }
}
    

