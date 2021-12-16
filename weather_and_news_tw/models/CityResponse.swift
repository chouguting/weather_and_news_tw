//
//  CityResponse.swift
//  weather_and_news_tw
//
//  Created by 周固廷 on 2021/12/11.
//

import Foundation

struct CityResponse: Codable{
    let name:String
    let local_names:localNames
    let lat:Double
    let lon:Double
    let country:String
}

struct localNames: Codable{
    let zh:String
}
