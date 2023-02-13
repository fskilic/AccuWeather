//
//  CityWeatherViewModel.swift
//  AccuWeatherApp
//
//  Created by FS K on 29.01.2023.
//

import Foundation

struct CityWeatherViewModel {
    var cityWeather: CityWeather
    
    func numberOfRowsInSection() -> Int {
        return self.cityWeather.DailyForecasts.count
    }
    
    func weatherDate(_ index:Int)-> String {
        return self.cityWeather.DailyForecasts[index].Date
    }
    
    func weatherDayTemperature(_ index:Int)-> String {
        return String(self.cityWeather.DailyForecasts[index].Temperature.Maximum.Value) + " °" + self.cityWeather.DailyForecasts[index].Temperature.Maximum.Unit
    }
    
    func  weatherDayIconPhrase(_ index:Int)-> String {
        return self.cityWeather.DailyForecasts[index].Day.IconPhrase
    }
    
    func weatherDayIcon(_ index:Int)-> Int {
        return self.cityWeather.DailyForecasts[index].Day.Icon
    }
    
    func weatherNightTemperature(_ index:Int)-> String {
        return String(self.cityWeather.DailyForecasts[index].Temperature.Minimum.Value) + " °" + self.cityWeather.DailyForecasts[index].Temperature.Minimum.Unit
    }
    
    func  weatherNightIconPhrase(_ index:Int)-> String {
        return self.cityWeather.DailyForecasts[index].Night.IconPhrase
    }
    
    func weatherNightIcon(_ index:Int)-> Int {
        return self.cityWeather.DailyForecasts[index].Night.Icon
    }
    
    
}
