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
    @Published var translatedTitle=[TraslateResponse]()
    @Published var nextPage = 1
    var currentLoading = false
    
    init(){
        fetchItems()
    }
    
    func refresh(){
        newArticles.removeAll()
        nextPage = 1
        fetchItems()
    }
    
    func translateTitle(searchResponse:NewsResponse){
        var urlComponents = URLComponents()
        urlComponents.host = "api.cognitive.microsofttranslator.com"
        urlComponents.scheme = "https"
        urlComponents.path = "/translate"
        urlComponents.queryItems = [
        //    URLQueryItem(name: "Authorization", value: "CWB-2A7B2253-4AD0-40B4-A832-B2F4B9DC667F"),
        //    URLQueryItem(name: "locationName", value: "臺北市"),
        //    URLQueryItem(name: "format", value: "JSON"),
            URLQueryItem(name: "api-version", value: "3.0"),
            URLQueryItem(name: "to", value: "lzh")

        ]
        
        let url=urlComponents.url!

        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        request.setValue("UTF-8", forHTTPHeaderField: "charset")
        request.setValue("25fb610d1ad9438da4eaa732ef218baf", forHTTPHeaderField: "Ocp-Apim-Subscription-Key")
        request.setValue("eastasia", forHTTPHeaderField: "Ocp-Apim-Subscription-Region")

        let encoder = JSONEncoder()
        var text = [TranslatePost]()
        for i in searchResponse.articles.indices{
            text.append(TranslatePost(text: searchResponse.articles[i].title))
        }
        
        let data = try? encoder.encode(text)

    
        request.httpBody = data
        URLSession.shared.dataTask(with: request) { data, response, error in
            if let data = data {
                do {
                    let decoder = JSONDecoder()

                    let translateResponse = try decoder.decode([TraslateResponse].self, from: data)
            
                    
                    
                    
                
                    var urlComponents2 = URLComponents()
                    urlComponents2.host = "api.cognitive.microsofttranslator.com"
                    urlComponents2.scheme = "https"
                    urlComponents2.path = "/translate"

                    urlComponents2.queryItems = [
                        URLQueryItem(name: "api-version", value: "3.0"),
                        URLQueryItem(name: "from", value: "zh-Hans"),
                        URLQueryItem(name: "to", value: "zh-Hant")

                    ]


                    let url2=urlComponents2.url!

                    var request2 = URLRequest(url: url2)
                    request2.httpMethod = "POST"
                    request2.setValue("application/json", forHTTPHeaderField: "Content-Type")
                    request2.setValue("UTF-8", forHTTPHeaderField: "charset")
                    request2.setValue("25fb610d1ad9438da4eaa732ef218baf", forHTTPHeaderField: "Ocp-Apim-Subscription-Key")
                    request2.setValue("eastasia", forHTTPHeaderField: "Ocp-Apim-Subscription-Region")


                    var text2 = [TranslatePost]()
                    for i in translateResponse.indices{
                        text2.append(TranslatePost(text: translateResponse[i].translations[0].text!))
                    }
                    
                    let data2 = try? encoder.encode(text2)
                    request2.httpBody = data2
                    URLSession.shared.dataTask(with: request2) { data, response, error in
                        if let data = data {
                            do {
                                let decoder = JSONDecoder()

                                let translateResponse = try decoder.decode([TraslateResponse].self, from: data)
                                
                                
                                DispatchQueue.main.async {
                                    print("PG:",self.nextPage)
                                    print("EE:",self.newArticles.indices.endIndex)
                                    print("EE2:",translateResponse.indices.endIndex)
                                    self.translatedTitle=translateResponse
                                    for i in translateResponse.indices{
                                        if let ltitle = translateResponse[i].translations[0].text{
                                            self.newArticles[self.newArticles.indices.endIndex-translateResponse.indices.endIndex+i].lTitle = ltitle
                                        }
                                    }
                                    
                                }
                            } catch  {
                                print(error)
                            }
                        }
                    }.resume()

                } catch  {
                    print(error)
                }
            }
        }.resume()
        
    }
    
    func fetchMore(currentItem:Article? = nil){
        if(!canLoadMore(currentItem: currentItem)){
            return
        }
        fetchItems()
    }
    
    func canLoadMore(currentItem:Article? = nil)->Bool{
        if currentLoading{
            return false
        }
        guard let currentItem = currentItem else {
            return true
        }
        
        guard let lastItem = newArticles.last else{
            return true
        }
        return currentItem.id == lastItem.id
        
        
    }
    
    
    func fetchItems() {
        currentLoading = true
        let urlStr = "https://newsapi.org/v2/top-headlines?country=tw&apiKey=513b64d14886482eab56eccf3b402a7b&page=\(nextPage)"
        if let url = URL(string: urlStr) {
            URLSession.shared.dataTask(with: url) { data, response , error in
                if let data = data {
                    do {
                        let decoder = JSONDecoder()
                        //decoder.dateDecodingStrategy = .iso8601
                        let searchResponse = try decoder.decode(NewsResponse.self, from:
                                                                    data)
                        if let content = String(data: data, encoding: .utf8) {
                            print(content)
                        }
                        //代表大括號內容由main thread執行
                        DispatchQueue.main.async {
                            self.newArticles += searchResponse.articles
                            self.translateTitle(searchResponse: searchResponse)
                            self.nextPage+=1
                            self.currentLoading = false
                        }
                    } catch {
                        print("News出問題",error)
                        self.currentLoading = false
                    }
                }
            }.resume()
        }
    }
}
