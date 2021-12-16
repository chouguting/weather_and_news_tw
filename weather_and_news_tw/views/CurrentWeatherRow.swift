//
//  CurrentWeatherRow.swift
//  weather_and_news_tw
//
//  Created by 周固廷 on 2021/12/17.
//

import SwiftUI

struct CurrentWeatherRow: View {
    var cityCurrentWeather:CityCurrentWeatherResponse
    var body: some View {
        HStack{
            AsyncImage(url: URL(string: "http://openweathermap.org/img/wn/\(cityCurrentWeather.weather[0].icon)@4x.png")!) { image in
                image
                    .resizable()
            } placeholder: {
                ProgressView()
            }
            .frame(width: 200, height: 200)
            VStack{
                Text("\(cityCurrentWeather.main.temp.format(f: ".2"))°C").font(.title2)
                Text(cityCurrentWeather.weather[0].description).font(.title)
            }
            
            
        }
       
    }
}


