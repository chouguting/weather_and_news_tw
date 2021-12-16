//
//  NewsViewModel.swift
//  weather_and_news_tw
//
//  Created by 周固廷 on 2021/12/12.
//

import Foundation
import SwiftUI
class NewsViewModel:ObservableObject{
    @Published var newArticles=[Article]()
    
    init(){
        fetchItems()
    }
    
    func fetchItems() {
        let urlStr = "https://newsapi.org/v2/top-headlines?country=tw&apiKey=8a7824f8481d436bab4bdfa2d966412f"
        if let url = URL(string: urlStr) {
            URLSession.shared.dataTask(with: url) { data, response , error in
                if let data = data {
                    do {
                        let decoder = JSONDecoder()
                        //decoder.dateDecodingStrategy = .iso8601
                        let searchResponse = try decoder.decode(NewsResponse.self, from:
                                                                    data)
                        //代表大括號內容由main thread執行
                        DispatchQueue.main.async {
                            self.newArticles = searchResponse.articles
                        
                        }
                    } catch {
                        print("News出問題",error)
                    }
                }
            }.resume()
        }
    }
}
