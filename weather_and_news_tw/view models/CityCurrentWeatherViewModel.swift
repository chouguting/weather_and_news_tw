//
//  CityCurrentWeatherViewModel.swift
//  weather_and_news_tw
//
//  Created by 周固廷 on 2021/12/16.
//

import Foundation
import SwiftUI

class CityCurrentWeatherViewModel:ObservableObject{
    
    
    @Published var currentWeather:CityCurrentWeatherResponse?
    

    
    func fetchItems(locationStr:String) {
        var urlComponents = URLComponents()
        urlComponents.host = "api.openweathermap.org"
        urlComponents.scheme = "http"
        urlComponents.path = "/data/2.5/weather"
        urlComponents.queryItems = [
            URLQueryItem(name: "q", value: locationStr),
            URLQueryItem(name: "appid", value: "a75de21e3b555f185ff15a33b41d845c"),
            URLQueryItem(name: "lang", value: "zh_tw"),
            URLQueryItem(name: "units", value: "metric")
            
        ]
        //let urlStr=urlComponents.url!
        //var request = URLRequest(url: url)
        
        if let url = urlComponents.url {
            URLSession.shared.dataTask(with: url) { data, response , error in
                if let data = data {
                    do {
                        let decoder = JSONDecoder()
                        //decoder.dateDecodingStrategy = .iso8601
                        let searchResponse = try decoder.decode(CityCurrentWeatherResponse.self, from:
                                                                    data)
                        //代表大括號內容由main thread執行
                        DispatchQueue.main.async {
                            self.currentWeather = searchResponse
                        }
                        
                    } catch {
                        print("Weather Current出問題",error)
                    }
                }
            }.resume()
        }
    }
}
