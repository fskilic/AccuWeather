//
//  CityWeather.swift
//  AccuWeatherApp
//
//  Created by FS K on 29.01.2023.
//

import Foundation



struct CityWeather : Decodable {
    var DailyForecasts : [DailyForecasts]
}

struct DailyForecasts : Decodable {
    var Date : String
    var Temperature : Temperature
    var Day : Day
    var Night : Night
}

struct Temperature : Decodable {
    var Minimum : Minimum
    var Maximum : Maximum
}

struct Minimum : Decodable {
    var Value : Double
    var Unit : String
}

struct Maximum : Decodable {
    var Value : Double
    var Unit : String
}

struct Day : Decodable {
    var Icon : Int
    var IconPhrase : String
}

struct Night : Decodable {
    var Icon : Int
    var IconPhrase : String
}
 
