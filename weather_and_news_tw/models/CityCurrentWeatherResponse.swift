//
//  CityCurrentWeatherResponse.swift
//  weather_and_news_tw
//
//  Created by 周固廷 on 2021/12/16.
//

import Foundation

struct CityCurrentWeatherResponse: Codable{
    let weather:[CityWeather]
    let main:CityMainTemp
    let wind:CityWind
    let clouds:CityClouds
    
}

struct CityWeather: Codable{
    let main:String
    let description:String
    let icon:String
}

struct CityMainTemp:Codable{
    let temp:Double
    let feels_like:Double
    let temp_min:Double
    let temp_max:Double
    let pressure:Double
    let humidity:Double
}

struct CityWind:Codable{
    let speed:Double?
    let deg:Double?
    let gust:Double?
}

struct CityClouds:Codable{
    let all:Int?
}
