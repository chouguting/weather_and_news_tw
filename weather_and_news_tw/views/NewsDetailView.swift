//
//  NewsDetailView.swift
//  weather_and_news_tw
//
//  Created by 周固廷 on 2021/12/12.
//

import SwiftUI

struct NewsDetailView: View {
    
    var theArticle:Article
    
    @StateObject var newsSearchViewModel = NewsSearchViewModel()
    
    @Environment(\.openURL) var openURL
    
    var body: some View {
        ScrollView(){
            VStack(alignment:.center){
                if let imageUrl = theArticle.urlToImage{
                    AsyncImage(url: URL(string: imageUrl)!) { image in
                        image
                            .resizable()
                            .scaledToFill()
                    } placeholder: {
                        Color.purple.opacity(0.1)
                    }
                    .frame(height: 300)
                    .clipped()
                }
                
                
                Text(theArticle.title).bold().font(.title).padding()
                if let description = theArticle.description{
                    Text(description).padding()
                }else{
                    Text("點擊連結以查看更多").padding()
                }
                
                Button("閱讀更多") {
                    openURL(URL(string: theArticle.url)!)
                }.buttonStyle(.bordered).padding()
                Spacer()
                Divider()
                Text("相關新聞：")
                
                
                
                ForEach(newsSearchViewModel.searchedNews){
                    item in
                    Link(item.name, destination: URL(string: item.url)!).padding()
                }.overlay{
                    if(newsSearchViewModel.searchedNews.isEmpty){
                        ProgressView()
                    }
                }
            }
            
            
            
            
            
        }.frame(maxWidth:UIScreen.screenWidth,alignment: .topLeading).edgesIgnoringSafeArea(.top).onAppear {
            let tempStr = theArticle.title.components(separatedBy: "-").dropLast().joined(separator: "-")
            newsSearchViewModel.fetchItems(searchStr: tempStr)
        }
    }
}

struct NewsDetailView_Previews: PreviewProvider {
    
    static var previews: some View {
        
        NewsDetailView(theArticle: Article(author: "Hi", title: "What??", description: "Today is a great day", url: "www.google.com", urlToImage: "https://img.ltn.com.tw/Upload/news/600/2021/12/11/phpWMMuCo.jpg", publishedAt: "2021-12-11T12:34:10Z"))
    }
}
