//
//  GetLocationView.swift
//  weather_and_news_tw
//
//  Created by 周固廷 on 2021/12/11.
//

import SwiftUI
import CoreLocationUI

struct GetLocationView: View {
    
    @Binding var requestingLocation:Bool
//    @State var selectCityIndex = 0
//    let cityList = ["台北","基隆"]
    
    @ObservedObject var cityViewModel:CityViewModel
    
    @EnvironmentObject var  locationManager:LocationManager
    @ObservedObject var cityForecastViewModel:CityWeatherForecastViewModel
    @ObservedObject var cityCurrentWeatherViewModel:CityCurrentWeatherViewModel
    
    
    
    var body: some View {
        VStack{
            
            Text("請提供位置").font(.title2).bold()
            Text("我目前的位置：\(cityViewModel.CityName)")
            
            Picker("選擇城市", selection: $cityViewModel.selectCityIndex) {
                ForEach(cityViewModel.cityList.indices){
                    i in
                    Text(cityViewModel.cityList[i]).font(.title)
                }
            }.pickerStyle(.inline)
            
           
            Button {
                if let location = locationManager.lastLocation{
                    cityViewModel.fetchItems(lat: location.coordinate.latitude, lon: location.coordinate.longitude)
                }
                cityViewModel.updateIndex()
            } label: {
                Text("使用我的位置")
            }

            
            
            Button {
                requestingLocation = false
                UserDefaults.standard.set(cityViewModel.selectCityIndex, forKey: "weatherCityIndex")
                cityForecastViewModel.fetchItems(locationStr: cityViewModel.cityList[cityViewModel.selectCityIndex])
                cityCurrentWeatherViewModel.fetchItems(locationStr: cityViewModel.cityEngList[cityViewModel.selectCityIndex])
            } label: {
                Text("完成")
            }.padding().buttonStyle(.bordered)
           

            
        }.onAppear(perform: {
            if let location = locationManager.lastLocation{

                cityViewModel.fetchItems(lat: location.coordinate.latitude, lon: location.coordinate.longitude)
            }
            
        }).frame(maxWidth: .infinity,maxHeight: .infinity)
    }
}

//struct GetLocationView_Previews: PreviewProvider {
//    @State static var value = true
//    static var previews: some View {
//
//        GetLocationView(requestingLocation: $value)
//    }
//}
