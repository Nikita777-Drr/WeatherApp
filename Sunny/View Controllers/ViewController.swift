//
//  ViewController.swift
//  Sunny
//
//  Created by Ivan Akulov on 24/02/2020.
//  Copyright © 2020 Ivan Akulov. All rights reserved.
//

import UIKit
import CoreLocation

class ViewController: UIViewController {

    @IBOutlet weak var weatherIconImageView: UIImageView!
    @IBOutlet weak var cityLabel: UILabel!
    @IBOutlet weak var temperatureLabel: UILabel!
    @IBOutlet weak var feelsLikeTemperatureLabel: UILabel!
    @IBOutlet weak var backgroundImage: UIImageView!
    
    //MARK: -  Создали экземпляр Запроса в сеть
    var networkManager = CurrentWeatherManager()
    
    lazy var locationManager:CLLocationManager = {
        let lm = CLLocationManager()
        lm.delegate = self
        //MARK: -  Точность до километра
        lm.desiredAccuracy = kCLLocationAccuracyKilometer
        //MARK: - Запрос на разрешение геопозиции
        lm.requestWhenInUseAuthorization()
        return lm
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
       
        
        //Передача данных через клоужер
        networkManager.onCompletion = {[weak self] currentWeather in
            self?.updateViewInterface(currentWeather)
        }
        
        //Передача данных через delegate
        //networkManager.delegate = self
        //MARK: -  Метод срабатывает, если пользователь дал разрешение на геопозицию
        if CLLocationManager.locationServicesEnabled(){
            locationManager.requestLocation()
        }else{
            networkManager.createURLResponce(forRequestType: .nameCity(urlString: "London"))
        }
    }
    
    
    
    @IBAction func searchPressed(_ sender: UIButton) {
        self.presentSearchAlertController(withTitle: "Enter city name", message: nil, style: .alert) {[weak self] city in
            self?.networkManager.createURLResponce(forRequestType: .nameCity(urlString: city.capitalized))
        }
    }
    
    func updateViewInterface(_ weather:CurrentWeatherHelper){
        DispatchQueue.main.async {
            self.cityLabel.text = weather.nameCity
            self.temperatureLabel.text = weather.temperatureString
            self.feelsLikeTemperatureLabel.text = weather.feelsTemperatureString
            self.weatherIconImageView.image = UIImage(systemName: weather.iconImageConditionString)
            self.backgroundImage.image = UIImage(named: weather.backbroundImageConditionString)
        }
    }
    
}
//Передача данных через delegate
//extension ViewController:CurrentWeatherManagerDelegate{
//    func updateIntarface(_: CurrentWeatherManager, with currentWeather: CurrentWeatherHelper) {
//        print(currentWeather.nameCity)
//    }
//
//
//}
//MARK: - CLLocationManagerDelegate расширение делегата геопозиции
extension ViewController:CLLocationManagerDelegate{
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        guard let location = locations.last else {return}
//MARK: -  Получаем геопозицию пользователя по широте и долготе
        let latitude = location.coordinate.latitude
        let longitude = location.coordinate.longitude
        
        networkManager.createURLResponce(forRequestType: .coordinate(latitude: latitude, longitude: longitude))
    }
    //MARK: - didFailWithError
    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        print(error.localizedDescription)
    }
}


