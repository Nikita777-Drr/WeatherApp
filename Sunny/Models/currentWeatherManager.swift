//
//  currentWeatherManager.swift
//  Sunny
//
//  Created by User on 02.02.2022.
//  Copyright © 2022 Ivan Akulov. All rights reserved.
//

import Foundation
import CoreLocation

//Передача данных через delegate
//protocol CurrentWeatherManagerDelegate:class{
//    func updateIntarface(_:CurrentWeatherManager, with currentWeather:CurrentWeatherHelper)
//}



class CurrentWeatherManager{
    //Передача данных через клоужер
    var onCompletion:((CurrentWeatherHelper)-> Void)?
    
    //Передача данных через delegate
    //weak var delegate:CurrentWeatherManagerDelegate?
    enum RequestType{
        case nameCity(urlString:String)
        case coordinate(latitude:CLLocationDegrees, longitude:CLLocationDegrees)
    }
    
    
    //MARK: - метод запроса в сеть
    func createURLResponce(forRequestType requetsType:RequestType){
        var urlString = ""
        
        switch requetsType{
        case .nameCity(let city):
            urlString = "https://api.openweathermap.org/data/2.5/weather?q=\(city)&appid=\(apiKey)&units=metric"
        case .coordinate(let latitude, let longitude):
            urlString = "https://api.openweathermap.org/data/2.5/weather?lat=\(latitude)&lon=\(longitude)&appid=\(apiKey)&units=metric"
        }
        perfrormRequest(withURLString: urlString)
    }
    
//    func createURLResponce(withCity city: String){
//        let urlString = "https://api.openweathermap.org/data/2.5/weather?q=\(city)&appid=\(apiKey)&units=metric"
//        perfrormRequest(withURLString: urlString)
//    }
//
//    func createURLResponce(forLatitude latitude:CLLocationDegrees, forLongitude longitude:CLLocationDegrees){
//        let urlString = "https://api.openweathermap.org/data/2.5/weather?lat=\(latitude)&lon=\(longitude)&appid=\(apiKey)&units=metric"
//        perfrormRequest(withURLString: urlString)
//    }
    fileprivate func perfrormRequest(withURLString urlString:String){
        guard let url = URL(string: urlString) else {return}
        let session = URLSession(configuration: .default)
        let task = session.dataTask(with: url) {data, responce, error in
            if let data = data {
                if let currentWeather = self.parseJSON(withData: data){
                    //Передача данных через клоужер
                    self.onCompletion?(currentWeather)
                    
                    //Передача данных через delegate
                    //self.delegate?.updateIntarface(self, with: currentWeather)
                }
            }
        }
        task.resume()
    }
    //MARK: - Метод для парсинга
    fileprivate func parseJSON(withData data:Data)->CurrentWeatherHelper?{
        let decoder = JSONDecoder()
            
        do {
            //MARK: -  Decode разпарсит созданную модель(WeatherDataModel) по запросу с сети
            let weatherDataModel = try decoder.decode(WeatherDataModel.self, from: data)
            guard let weatherData = CurrentWeatherHelper(weatherDataModel: weatherDataModel) else {return nil}
            return weatherData
            
        } catch let error as NSError {
            print(error.localizedDescription)
        }
        return nil
    }
}
