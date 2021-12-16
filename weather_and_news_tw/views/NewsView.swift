//
//  NewsView.swift
//  weather_and_news_tw
//
//  Created by 周固廷 on 2021/12/11.
//

import SwiftUI

struct NewsView: View {
    @StateObject var newsViewModel = NewsViewModel()
    
    var body: some View {
        NavigationView {
            List{
                ForEach(newsViewModel.newArticles){
                    item in
                    let tempStr = item.title.components(separatedBy: "-").dropLast().joined(separator: "-")
                    
    //                Link(tempStr, destination: URL(string: item.url)!)
                    NavigationLink(tempStr) {
                        NewsDetailView(theArticle: item)
                    }

                }
            }.overlay{
                if(newsViewModel.newArticles.isEmpty){
                    ProgressView()
                }
            }.refreshable {
                newsViewModel.fetchItems()
            }.navigationTitle("新聞")
        }
    }
}

struct NewsView_Previews: PreviewProvider {
    
    static var previews: some View {
        NewsView()
    }
}
