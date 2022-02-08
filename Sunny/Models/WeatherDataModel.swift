//
//  WeatherDataModel.swift
//  Sunny
//
//  Created by User on 03.02.2022.
//  Copyright © 2022 Ivan Akulov. All rights reserved.
//

import Foundation

struct WeatherDataModel:Codable{
    let name:String
    let main:Main
    let weather:[Weather]
}

struct Main:Codable{
    let temp:Double
    let feelsLike:Double
    
    enum CodingKeys:String, CodingKey{
        case temp
        case feelsLike = "feels_like"
    }
}
struct Weather:Codable{
    let id:Int
    let main:String
}
