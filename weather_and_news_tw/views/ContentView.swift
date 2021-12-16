//
//  ContentView.swift
//  weather_and_news_tw
//
//  Created by 周固廷 on 2021/12/11.
//

import SwiftUI

extension UIScreen{
   static let screenWidth = UIScreen.main.bounds.size.width
   static let screenHeight = UIScreen.main.bounds.size.height
   static let screenSize = UIScreen.main.bounds.size
}

struct ContentView: View {
    @StateObject var networkMonitor = NetworkMonitor()
    var body: some View {
        if(networkMonitor.status == .connected){
            TabView {
                WeatherView().tabItem {
                    Label("天氣",systemImage: "cloud.fill")
                }
                NewsView().tabItem {
                    Label("新聞",systemImage: "newspaper.fill")
                }
            }
        }else{
            NoNetworkView(networkMonitor: networkMonitor)
        }
        
        
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
