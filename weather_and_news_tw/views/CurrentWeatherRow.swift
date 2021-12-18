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
        
        VStack(alignment:.leading) {
            HStack{
                AsyncImage(url: URL(string: "http://openweathermap.org/img/wn/\(cityCurrentWeather.weather[0].icon)@4x.png")!) { image in
                    image
                        .resizable()
                } placeholder: {
                    ProgressView()
                }
                .frame(width: 200, height: 200)
                VStack{
                    //Text("\(cityCurrentWeather.weather[0].icon)")
                    Text("\(cityCurrentWeather.main.temp.format(f: ".2"))°C").font(.title2)
                    Text(cityCurrentWeather.weather[0].description).font(.title)
                } 
            }
            Text("體感溫度: \(cityCurrentWeather.main.feels_like.format(f: ".2"))°C").padding([.leading,.top]).font(.title3)
            Text("最高溫: \(cityCurrentWeather.main.temp_max.format(f: ".2"))°C    最低溫: \(cityCurrentWeather.main.temp_min.format(f: ".2"))°C").padding(.leading)
           
            Text("氣壓: \(cityCurrentWeather.main.pressure.format(f: ".1")) hPa").padding([.leading,.top])
            Text("濕度: \(cityCurrentWeather.main.humidity.format(f: ".1")) %").padding([.leading])
        }
       
    }
}


