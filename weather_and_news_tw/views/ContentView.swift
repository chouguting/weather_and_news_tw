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
    @State private var showAlert = false
    @State var openWeb = false
    @State private var selectedNews: SelectedNews? = nil
    //let persistenceController = PersistenceController.shared
    
    @Environment(\.managedObjectContext) private var viewContext
    
    @State var pageTitle = ""
    @State var pageUrl = URL(string: "www.google.com")!
    
    var body: some View {
        if(networkMonitor.status == .connected){
            TabView {
                WeatherView().tabItem {
                    Label("天氣",systemImage: "cloud.fill")
                }
                NewsView().tabItem {
                    Label("新聞",systemImage: "newspaper.fill")
                }
                SearchView().tabItem {
                    Label("搜尋",systemImage: "magnifyingglass")
                }
                CollectionView().tabItem {
                    Label("收藏",systemImage: "star")
                }
            }.onOpenURL { URL in
                pageUrl = URL
//                let theUrl = URL.absoluteString
//                let splittedUrl = theUrl.split(separator: "，")
//                let realUrl = splittedUrl[0]
//                let realTitle = splittedUrl[1]
//                self.selectedNews = SelectedNews(url: String(realUrl), title: String(realTitle))
                openWeb = true
            }.sheet(isPresented: $openWeb, onDismiss: {
                pageTitle = ""
            },content: {
                //WebView(urlStr: $0)
                //Text("AAAAA\(pageTitle)")
                if(!pageTitle.isEmpty){
                    Button(action: addItem) {
                        Label("收藏", systemImage: "plus")
                    }.padding()
                }
                
                WebViewForWidget(title: $pageTitle, urlStr: $pageUrl)
                
            })
        }else{
            NoNetworkView(networkMonitor: networkMonitor).onAppear {
                showAlert=true
            }.alert("No connection", isPresented: $showAlert, actions: {
                Button("OK") { }
            })
        }
        
        
    }
    
    private func addItem() {
        withAnimation {
            let newItem = SavedNews(context: viewContext)
            newItem.saveTime = Date()
            newItem.title = pageTitle
            newItem.url = pageUrl.absoluteString
            print(newItem)

            do {
                try viewContext.save()
            } catch {
                // Replace this implementation with code to handle the error appropriately.
                // fatalError() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.
                let nsError = error as NSError
                fatalError("Unresolved error \(nsError), \(nsError.userInfo)")
            }
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
