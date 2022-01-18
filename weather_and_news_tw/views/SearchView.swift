//
//  SearchView.swift
//  weather_and_news_tw
//
//  Created by 周固廷 on 2022/1/12.
//

import SwiftUI

extension View {
  func endTextEditing() {
    UIApplication.shared.sendAction(#selector(UIResponder.resignFirstResponder),
                                    to: nil, from: nil, for: nil)
  }
}

struct SearchView: View {
    
    @StateObject var customSearch = NewsSearchViewModel()
    @State private var showWebpage = false
    @State var firstSearch = true
    @State private var searchString = ""
    var body: some View {
        
        VStack {
            Text("新聞搜尋").font(.largeTitle)
            SearchBar(text: $searchString,onSearchButtonClicked: {
                customSearch.fetchItems(searchStr: searchString)
                self.endTextEditing()
                firstSearch = false
            }).padding()

            if(!firstSearch){
                List{
                    ForEach(customSearch.searchedNews){
                        item in
    //                    Link(item.name, destination: URL(string: item.url)!).padding()
                        Button(item.name) {
                            showWebpage = true
                        }
                        .sheet(isPresented: $showWebpage) {
                            //WebView(urlStr: item.url)
                            NewsWebView(newsTitle: item.name,newsUrl: item.url)
                        }
                    }.overlay{
                        if(customSearch.searchedNews.isEmpty){
                            ProgressView()
                        }
                    }
                }
            }
            
            
            
        }
    }
}

struct SearchView_Previews: PreviewProvider {
    static var previews: some View {
        SearchView()
    }
}
