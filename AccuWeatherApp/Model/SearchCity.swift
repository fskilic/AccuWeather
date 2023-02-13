//
//  AccuWeather.swift
//  AccuWeatherApp
//
//  Created by FS K on 28.01.2023.
//

import Foundation

struct SearchCity : Decodable {
    var Key : String
    var LocalizedName : String
    var Country : Country
    var AdministrativeArea : AdministrativeArea
}

struct Country : Decodable {
    var ID : String
    var LocalizedName : String
}
    
struct AdministrativeArea : Decodable {
    var ID : String
    var LocalizedName : String
}


