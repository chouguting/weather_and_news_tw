//
//  NewsWebView.swift
//  weather_and_news_tw
//
//  Created by 周固廷 on 2022/1/14.
//

import SwiftUI

struct NewsWebView: View {
    @Environment(\.managedObjectContext) private var viewContext
    
    let newsTitle:String
    let newsUrl:String
    
    var body: some View {
        VStack{
            Button(action: addItem) {
                Label("收藏", systemImage: "plus")
            }.padding()
            WebView(urlStr: newsUrl)
            
        }
    }
    
    private func addItem() {
        withAnimation {
            let newItem = SavedNews(context: viewContext)
            newItem.saveTime = Date()
            newItem.title = newsTitle
            newItem.url = newsUrl

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

struct NewsWebView_Previews: PreviewProvider {
    static var previews: some View {
        NewsWebView(newsTitle:"Test" ,newsUrl: "https://www.google.com")
    }
}
