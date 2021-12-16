//
//  CityWeatherResponse.swift
//  weather_and_news_tw
//
//  Created by 周固廷 on 2021/12/11.
//

import Foundation

struct CityWeatherForecastResponse:Codable{
    let success:String
    let records:RecordList
    
}

struct RecordList: Codable{
    let datasetDescription: String
    let location: [LocationRecord]
}

struct LocationRecord:Codable,Identifiable{
    var id: String{locationName}
    let locationName:String
    let weatherElement:[LocationWeather]

}

struct LocationWeather:Codable,Identifiable{
    var id: String{elementName}
    let elementName:String
    let time:[TimeWeather]
}


struct TimeWeather:Codable,Identifiable{
    var id:String{startTime}
    let startTime:String
    let endTime:String
    let parameter:WeatherParameter
}

struct WeatherParameter:Codable{
    let parameterName:String
}



