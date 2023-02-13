//
//  SearchCityViewModel.swift
//  AccuWeatherApp
//
//  Created by FS K on 29.01.2023.
//

import Foundation

struct SearchCityListViewModel {
    let searchCityList : [SearchCity]
    
    func numberOfRowsInSection() -> Int {
        return self.searchCityList.count
    }
    
    func cityAtIndex(_ index: Int) -> SearchCityViewModel {
        let city = self.searchCityList[index]
        return SearchCityViewModel(searchCity: city)
    }
}

struct SearchCityViewModel {
    let searchCity : SearchCity
    
    var cityName : String {
        return self.searchCity.LocalizedName
    }
    
    var regionName : String {
        return self.searchCity.AdministrativeArea.LocalizedName + ", " + self.searchCity.Country.LocalizedName
    }
    
    var administrativeArea : String {
        return self.searchCity.AdministrativeArea.LocalizedName
    }
    
    var countryName : String {
        return self.searchCity.Country.LocalizedName
    }
    
    var cityId : String {
        return self.searchCity.Key
    }
}
