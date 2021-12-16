//
//  NoNetwortView.swift
//  weather_and_news_tw
//
//  Created by 周固廷 on 2021/12/17.
//

import SwiftUI

struct NoNetworkView: View {
    @ObservedObject var networkMonitor:NetworkMonitor
    var body: some View {
        
        VStack {
            Image(systemName: "wifi.exclamationmark").resizable().scaledToFit().frame(width: UIScreen.screenWidth*0.4, alignment: .center).padding()
            Text("沒有網路連線😢").font(.title)
            Text("當您連上網路時，一切都會變得不一樣")
        }.refreshable {
            
        }
        
    }
}

struct NoNetworkView_Previews: PreviewProvider {
    static var networkMonitorTemp = NetworkMonitor()
    static var previews: some View {
        NoNetworkView(networkMonitor: networkMonitorTemp)
    }
}
