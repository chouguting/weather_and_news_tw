//
//  NewsSearchViewModel.swift
//  weather_and_news_tw
//
//  Created by 周固廷 on 2021/12/12.
//

import Foundation

class NewsSearchViewModel:ObservableObject{
    @Published var searchedNews=[SearchedNews]()

    
    func fetchItems(searchStr:String) {

        var urlComponents = URLComponents()
        urlComponents.host = "api.bing.microsoft.com"
        urlComponents.scheme = "https"
        urlComponents.path = "/v7.0/news/search"
        urlComponents.queryItems = [
            URLQueryItem(name: "q", value: searchStr)
        ]
        
        if let url = urlComponents.url {
            var request = URLRequest(url: url)
            request.setValue("9bbd3a0ddd8a4e13976fb979ff78a267", forHTTPHeaderField: "Ocp-Apim-Subscription-Key")
            URLSession.shared.dataTask(with: request) { data, response , error in
                if let data = data {
                    do {
                        let decoder = JSONDecoder()
                        //decoder.dateDecodingStrategy = .iso8601
                        let searchResponse = try decoder.decode(NewsSearchResponse.self, from: data)
                        //代表大括號內容由main thread執行
                        DispatchQueue.main.async {
                            self.searchedNews = searchResponse.value
                        
                        }
                    } catch {
                        print("News search出問題",error)
                    }
                }
            }.resume()
        }
    }
}
