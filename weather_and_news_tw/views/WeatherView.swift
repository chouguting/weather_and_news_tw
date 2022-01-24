//
//  WeatherView.swift
//  weather_and_news_tw
//
//  Created by 周固廷 on 2021/12/11.
//

import SwiftUI

extension Double {
    func format(f: String) -> String {
        return String(format: "%\(f)f", self)
    }
}

struct WeatherView: View {
    
    @StateObject var weatherNews = NewsSearchViewModel()
    @StateObject var locationManager = LocationManager() //取得座標
    @StateObject var cityViewModel = CityViewModel() //把座標轉成城市的API
     
    @StateObject var cityWeatherForecastViewModel = CityWeatherForecastViewModel() //中央氣象局的預報API
    
    @StateObject var cityCurrentWeatherViewModel = CityCurrentWeatherViewModel() //open Weather的目前天氣API
    
    @State var requestingLocation = false
    @State var showWebpage = false
    private var idiom : UIUserInterfaceIdiom { UIDevice.current.userInterfaceIdiom }
    
    var body: some View {
        VStack{
            
            if(requestingLocation){
                GetLocationView(requestingLocation: $requestingLocation, cityViewModel: cityViewModel,cityForecastViewModel: cityWeatherForecastViewModel,cityCurrentWeatherViewModel: cityCurrentWeatherViewModel).environmentObject(locationManager)
            }else{
                
                
                
                List {
                    Section(header:Text("目前天氣")){
                        
                        //Text("Test")
                        if let cityCurrentWeather = cityCurrentWeatherViewModel.currentWeather{
                            CurrentWeatherRow(cityCurrentWeather: cityCurrentWeather).gesture(DragGesture(minimumDistance: 0, coordinateSpace: .local)
                                                                                                .onEnded({ value in
                                if value.translation.width < 0 {
                                    // 向左滑
                                    if let url = URL(string: "https://www.cwb.gov.tw/V8/C/") {
                                           UIApplication.shared.open(url)
                                        }
                                }
                                
                                if value.translation.width > 0 {
                                    // 向右滑
                                    if let url = URL(string: "https://openweathermap.org/") {
                                        UIApplication.shared.open(url)
                                    }
                                }
                                
                            }))
                            
                            
                        }else{
                            Text("loading...")
                        }
                    }
                    
                    if(idiom != .pad){
                        Button(action: shareButton) {
                            Label("分享", systemImage: "square.and.arrow.up")
                        }
                    }
                    
                    
                    ForEach(cityWeatherForecastViewModel.weatherRecord) { item in
                        let timeslices_brief = item.weatherElement[0].time
                        let timeslices_PoP = item.weatherElement[1].time
                        let timeslices_minTemp = item.weatherElement[2].time
                        let timeslices_description = item.weatherElement[3].time
                        let timeslices_maxTemp = item.weatherElement[4].time
                        ForEach(timeslices_brief.indices){
                            j in
                            Section(header: Text("\((j)*6)～\((j+1)*6)小時內的天氣")){
                               // let weather_info = timeslices_brief[j].parameter.parameterName+" - "+timeslices_description[j]
                                Text("\(timeslices_brief[j].parameter.parameterName): \(timeslices_description[j].parameter.parameterName)")
                                
                                Text("溫度: \(timeslices_minTemp[j].parameter.parameterName) ~ \(timeslices_maxTemp[j].parameter.parameterName)°C")
                                Text("降雨機率: "+timeslices_PoP[j].parameter.parameterName+"%")
                                
                            }
                            
            
                        }
                        Section(header: Text("天氣新聞")) {
                            ForEach(weatherNews.searchedNews){
                                item in
        
                                Button(item.name) {
                                    showWebpage = true
                                }.padding()
                                .sheet(isPresented: $showWebpage) {
                                    //WebView(urlStr: item.url)
                                    NewsWebView(newsTitle: item.name,newsUrl: item.url)
                                }
                            }
                        }
                        
                    }
                }.overlay{
                    if(cityWeatherForecastViewModel.weatherRecord.isEmpty){
                        ProgressView()
                    }
                }.refreshable {
                    weatherNews.fetchItems(searchStr: "天氣")
                    cityWeatherForecastViewModel.fetchItems(locationStr: cityViewModel.cityList[cityViewModel.selectCityIndex])
                    cityCurrentWeatherViewModel.fetchItems(locationStr: cityViewModel.cityEngList[cityViewModel.selectCityIndex])
                }
                
                HStack(spacing:20){
                    Text("使用的位置：\(cityViewModel.cityList[cityViewModel.selectCityIndex])")
                    Button {
                        requestingLocation = true
                    } label: {
                        Text("更改位置")
                    }.padding()
                }
                
                

            }
            
        }.onAppear {
            if let location = locationManager.lastLocation{

                cityViewModel.fetchItems(lat: location.coordinate.latitude, lon: location.coordinate.longitude)
            }
            weatherNews.fetchItems(searchStr: "天氣")
            cityViewModel.updateIndex()
            cityWeatherForecastViewModel.fetchItems(locationStr: cityViewModel.cityList[cityViewModel.selectCityIndex])
            cityCurrentWeatherViewModel.fetchItems(locationStr: cityViewModel.cityEngList[cityViewModel.selectCityIndex])
        }
        
        
    }
    
    func shareButton() {
            let url = URL(string: "https://www.cwb.gov.tw/V8/C/")
        
            let activityController = UIActivityViewController(activityItems: [url!], applicationActivities: nil)

            UIApplication.shared.windows.first?.rootViewController!.present(activityController, animated: true, completion: nil)
    }
}

struct WeatherView_Previews: PreviewProvider {
    static var previews: some View {
        WeatherView()
    }
}
