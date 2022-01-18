//
//  NewsDetailView.swift
//  weather_and_news_tw
//
//  Created by 周固廷 on 2021/12/12.
//

import SwiftUI

extension String: Identifiable {
    public var id: String { self }
}

struct SelectedNews: Identifiable{
    public var id: String { url+title }
    var url: String
    var title: String
}

struct NewsDetailView: View {
    
    var theArticle:Article
    
    @StateObject var newsSearchViewModel = NewsSearchViewModel()
    
    @Environment(\.managedObjectContext) private var viewContext
    
    @Environment(\.openURL) var openURL
    @State var showWebpage = false
    @State var showMainWebpage = false
    @State private var selectedURL: String? = nil
    @State private var selectedTitle: String? = nil
    @State private var selectedNews: SelectedNews? = nil
    
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
                    showMainWebpage = true
                }.sheet(isPresented: $showMainWebpage) {
                    WebView(urlStr: theArticle.url)
                }.buttonStyle(.bordered).padding()
                
                Spacer()
                
                Button(action: addItem) {
                    Label("收藏", systemImage: "plus")
                }
               
                Divider()
                Text("相關新聞：")
                
                
                
                ForEach(newsSearchViewModel.searchedNews){
                    item in
//                    Link(item.name, destination: URL(string: item.url)!).padding()
                    Button(item.name) {
                        self.selectedURL = item.url
                        self.selectedTitle = item.name
                        self.selectedNews = SelectedNews(url: item.url, title: item.name)
                        showWebpage = true
                    }
                    
                }.overlay{
                    if(newsSearchViewModel.searchedNews.isEmpty){
                        ProgressView()
                    }
                }.sheet(item:self.$selectedNews,content: {
                    NewsWebView(newsTitle: $0.title, newsUrl: $0.url)
                }).padding()
            }
            
            
            
            
            
        }.frame(maxWidth:UIScreen.screenWidth,alignment: .topLeading).edgesIgnoringSafeArea(.top).onAppear {
            let tempStr = theArticle.title.components(separatedBy: "-").dropLast().joined(separator: "-")
            newsSearchViewModel.fetchItems(searchStr: tempStr)
        }
    }
    
    private func addItem() {
        withAnimation {
            let newItem = SavedNews(context: viewContext)
            newItem.saveTime = Date()
            newItem.title = theArticle.title
            newItem.url = theArticle.url

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

struct NewsDetailView_Previews: PreviewProvider {
    
    static var previews: some View {
        
        NewsDetailView(theArticle: Article(author: "Hi", title: "What??", description: "Today is a great day", url: "www.google.com", urlToImage: "https://img.ltn.com.tw/Upload/news/600/2021/12/11/phpWMMuCo.jpg", publishedAt: "2021-12-11T12:34:10Z"))
    }
}
