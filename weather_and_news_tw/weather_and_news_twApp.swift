//
//  weather_and_news_twApp.swift
//  weather_and_news_tw
//
//  Created by 周固廷 on 2021/12/11.
//

import SwiftUI

@main
struct weather_and_news_twApp: App {
    let persistenceController = PersistenceController.shared
    var body: some Scene {
        WindowGroup {
            ContentView().environment(\.managedObjectContext, persistenceController.container.viewContext)
        }
    }
}
