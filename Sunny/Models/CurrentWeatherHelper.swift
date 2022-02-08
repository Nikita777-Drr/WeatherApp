//
//  CurrentWeatherHelper.swift
//  Sunny
//
//  Created by User on 03.02.2022.
//  Copyright © 2022 Ivan Akulov. All rights reserved.
//

import Foundation

//MARK: - помошник, который помогает передавать данные в нужном формате
struct CurrentWeatherHelper{
    let nameCity:String
    var temperature:Double
    var temperatureString:String{
        return String(format: "%.0f", temperature)
    }
    let feelsTemperature:Double
    var feelsTemperatureString:String{
        return String(format: "%.0f", feelsTemperature)
    }
    
    let conditionWeather:Int
    
    var iconImageConditionString:String{
        switch conditionWeather {
        case 200...232:
            return "cloud.bolt.rain.fill"
        case 300...321:
            return "cloud.drizzle.fill"
        case 500...531:
            return "cloud.rain.fill"
        case 600...622:
            return "cloud.snow.fill"
        case 701...781:
            return "cloud.fog.fill"
        case 800:
            return "cloud.sun.fill"
        case 801...804:
            return "icloud.fill"
        default:
            return "nosign"
        }
    }
    var backbroundImageConditionString:String{
        switch conditionWeather {
        case 200...232:
            return "гроза"
        case 300...321:
            return "морось"
        case 500...531:
            return "дождь"
        case 600...622:
            return "снег"
        case 701...781:
            return "туман"
        case 800:
            return "солнце"
        case 801...804:
            return "облачно"
        default:
            return "ночь"
        }
    }
    
    init?(weatherDataModel:WeatherDataModel){
        nameCity = weatherDataModel.name
        temperature = weatherDataModel.main.temp
        feelsTemperature = weatherDataModel.main.feelsLike
        conditionWeather = weatherDataModel.weather.first!.id
    }
}
