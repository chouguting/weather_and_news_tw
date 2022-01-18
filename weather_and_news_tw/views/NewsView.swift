//
//  NewsView.swift
//  weather_and_news_tw
//
//  Created by 周固廷 on 2021/12/11.
//

import SwiftUI
import RefreshableScrollView


struct NewsView: View {
    
    @Environment(\.managedObjectContext) private var viewContext

    
    
    @StateObject var newsViewModel = NewsViewModel()
    @State var showSheet = false
   
    @State private var selectedArticle: Article? = nil
    private var twoColumnGrid = [GridItem(.adaptive(minimum: 500),spacing: 0)]
    @State var refresh = false
    
    var body: some View {
        
        RefreshableScrollView(refreshing: $refresh,action: {
            // add your code here
            newsViewModel.refresh()
            // remmber to set the refresh to false
            DispatchQueue.main.asyncAfter(deadline: .now() + 2) {
                self.refresh = false
            }
        }) {
            LazyVGrid(columns: twoColumnGrid,spacing: 5){
                //VStack {
                if(!newsViewModel.newArticles.isEmpty && !newsViewModel.translatedTitle.isEmpty){
                    ForEach(newsViewModel.newArticles.indices,id: \.self){
                        i in
                        
                        Button {
                            showSheet = true
                            selectedArticle = newsViewModel.newArticles[i]
                        } label: {
                            NewsRow(arcticle: newsViewModel.newArticles[i])
                        }.onAppear {
                            newsViewModel.fetchMore(currentItem: newsViewModel.newArticles[i])
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
            newsViewModel.refresh()
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
