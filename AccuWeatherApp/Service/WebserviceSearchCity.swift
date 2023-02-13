//
//  Webservice.swift
//  AccuWeatherApp
//
//  Created by FS K on 28.01.2023.
//

import Foundation
import UIKit

class WebserviceSearchCity {
    
    func downloadCities(url: URL, completion: @escaping ([SearchCity]?) -> ()) {
        
        URLSession.shared.dataTask(with: url) { data, response, error in
            if let error = error {
                
                print(error.localizedDescription)
                completion(nil)
                
            }
            else if let data = data {
               
                let cityList = try? JSONDecoder().decode([SearchCity].self, from: data)
                
                if let cityList = cityList {
            
                    completion(cityList)
                    
                }
            }
            
        }.resume()
    }
    
    func downloadCurrentLocation(url: URL, completion: @escaping (SearchCity?) -> ()) {
        
        URLSession.shared.dataTask(with: url) { data, response, error in
            if let error = error {
                
                print(error.localizedDescription)
                completion(nil)

            }
            else if let data = data {
                
                let currentCity = try? JSONDecoder().decode(SearchCity.self, from: data)
                
                if let currentCity = currentCity {
                    completion(currentCity)
                }
            }
        }.resume()
    }
    
    
   
    
}

