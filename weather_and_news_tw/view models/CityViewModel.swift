//
//  CityViewModel.swift
//  weather_and_news_tw
//
//  Created by 周固廷 on 2021/12/11.
//

import Foundation

class CityViewModel: ObservableObject {
    
    @Published var CityName:String = ""
    @Published var ChineseCityName:String = ""
    @Published var selectCityIndex = 0
    let cityList = ["新北市","高雄市","臺中市","臺北市","桃園市","臺南市","彰化縣","屏東縣","雲林縣","苗栗縣","嘉義縣","新竹縣","南投縣","宜蘭縣","新竹市","基隆市","花蓮縣","嘉義市","臺東縣","金門縣","澎湖縣","連江縣"]
    let cityEngList = ["taipei","kaohsiung","taichung","taipei","taoyuan","tainan","changhua","pingtung","tublib","maioli","chiayi","hsinchu","nantuo","yilan","hsinchu","keelung","hualien","chiayi","taitung","kinmen","penghu","lienchiang"]
    
    func updateIndex(){
        if let seekIndex = cityList.firstIndex(of: ChineseCityName){
            selectCityIndex = seekIndex
        }
        
    }
    
    func fetchItems(lat: Double,lon: Double) {
        let urlStr = "http://api.openweathermap.org/geo/1.0/reverse?lat=\(lat)&lon=\(lon)&limit=5&appid=a75de21e3b555f185ff15a33b41d845c"
        if let url = URL(string: urlStr) {
            URLSession.shared.dataTask(with: url) { data, response , error in
                if let data = data {
                    do {
                        let decoder = JSONDecoder()
                        //decoder.dateDecodingStrategy = .iso8601
                        let searchResponse = try decoder.decode([CityResponse].self, from:
                                                                    data)
                        //代表大括號內容由main thread執行
                        DispatchQueue.main.async {
                            self.CityName = searchResponse[0].name
                            self.ChineseCityName = searchResponse[0].local_names.zh
                        }
                        
                    } catch {
                        print("City出問題",error)
                    }
                }
            }.resume()
        }
    }
}
