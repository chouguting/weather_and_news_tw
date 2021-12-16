//
//  CityWeatherForecastResponse.swift
//  weather_and_news_tw
//
//  Created by 周固廷 on 2021/12/12.
//

import Foundation

class CityWeatherForecastViewModel:ObservableObject{
    
    
    @Published var weatherRecord = [LocationRecord]()
    
    func fetchItems(locationStr:String) {
        var urlComponents = URLComponents()
        urlComponents.host = "opendata.cwb.gov.tw"
        urlComponents.scheme = "https"
        urlComponents.path = "/api/v1/rest/datastore/F-C0032-001"
        urlComponents.queryItems = [
            URLQueryItem(name: "Authorization", value: "CWB-2A7B2253-4AD0-40B4-A832-B2F4B9DC667F"),
            URLQueryItem(name: "locationName", value: locationStr),
            URLQueryItem(name: "format", value: "JSON"),
            URLQueryItem(name: "limit", value: "3")
            
        ]
        //let urlStr=urlComponents.url!
        //var request = URLRequest(url: url)
        
        if let url = urlComponents.url {
            URLSession.shared.dataTask(with: url) { data, response , error in
                if let data = data {
                    do {
                        let decoder = JSONDecoder()
                        //decoder.dateDecodingStrategy = .iso8601
                        let searchResponse = try decoder.decode(CityWeatherForecastResponse.self, from:
                                                                    data)
                        //代表大括號內容由main thread執行
                        DispatchQueue.main.async {
                            self.weatherRecord = searchResponse.records.location
                        }
                        
                    } catch {
                        print("Weather Forecast出問題",error)
                    }
                }
            }.resume()
        }
    }
}

