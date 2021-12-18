//
//  NewsView.swift
//  weather_and_news_tw
//
//  Created by 周固廷 on 2021/12/11.
//

import SwiftUI
import RefreshableScrollView


struct NewsView: View {
    @StateObject var newsViewModel = NewsViewModel()
    @State var showSheet = false
   
    @State private var selectedArticle: Article? = nil
    private var twoColumnGrid = [GridItem(.adaptive(minimum: 500),spacing: 0)]
    @State var refresh = false
    
    var body: some View {
        
        RefreshableScrollView(refreshing: $refresh,action: {
            // add your code here
            newsViewModel.fetchItems()
            // remmber to set the refresh to false
            DispatchQueue.main.asyncAfter(deadline: .now() + 2) {
                self.refresh = false
            }
        }) {
            LazyVGrid(columns: twoColumnGrid,spacing: 5){
                
                if(!newsViewModel.newArticles.isEmpty){
                    ForEach(newsViewModel.newArticles){
                        item in
                        
                        Button {
                            showSheet = true
                            selectedArticle = item
                        } label: {
                            NewsRow(arcticle: item)
                        }
                        //                    .sheet(isPresented: $showSheet) {
                        //
                        //                        NewsDetailView(theArticle: item)
                        //
                        //
                        //                    }
                        
                    }
                }
            }
        }.overlay{
            if(newsViewModel.newArticles.isEmpty){
                ProgressView()
            }
        }.refreshable {
            newsViewModel.fetchItems()
        }.navigationTitle("新聞").listRowSeparator(.hidden).sheet(item: self.$selectedArticle) { item in
            NewsDetailView(theArticle: item)
        }
    }
}

struct NewsView_Previews: PreviewProvider {
    
    static var previews: some View {
        NewsView()
    }
}
