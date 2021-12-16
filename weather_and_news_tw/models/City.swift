//
//  City.swift
//  weather_and_news_tw
//
//  Created by 周固廷 on 2021/12/11.
//

import Foundation

class City:ObservableObject{
    @Published var cityName:String
    
    init(){
        cityName=""
    }
}

