//
//  newsWidget.swift
//  newsWidget
//
//  Created by 周固廷 on 2022/1/13.
//

import WidgetKit
import SwiftUI

struct TranslatePost: Encodable {
    let text: String
}

struct TraslateResponse: Decodable{
    let translations:[TranslateInner]
}

struct TranslateInner:Decodable{
    let text: String?
    let to: String?
}


struct NewsResponse: Codable {
    let status:String?
    let totalResults:Int?
    var articles:[Article]
    
}

struct Article:Codable,Identifiable{
    var id: String{url}
    let author:String?
    let title:String
    let description:String?
    let url:String
    let urlToImage:String?
    let publishedAt:String?
    var lTitle:String?
}



struct Provider: TimelineProvider {
    
    
    func placeholder(in context: Context) -> SimpleEntry {
        SimpleEntry(date: Date(),newsTitle: ["AAAA"],newsUrl: ["www.google.com"])
    }

    func getSnapshot(in context: Context, completion: @escaping (SimpleEntry) -> ()) {
        let entry = SimpleEntry(date: Date(),newsTitle: ["AAAA"],newsUrl: ["www.google.com"])
        completion(entry)
    }

    func getTimeline(in context: Context, completion: @escaping (Timeline<Entry>) -> ()) {
        var entries: [SimpleEntry] = []
        
        let urlStr = "https://newsapi.org/v2/top-headlines?country=tw&pageSize=5&apiKey=513b64d14886482eab56eccf3b402a7b"
        if let url = URL(string: urlStr) {
            URLSession.shared.dataTask(with: url) { data, response , error in
                if let data = data {
                    do {
                        let decoder = JSONDecoder()
                        //decoder.dateDecodingStrategy = .iso8601
                        var searchResponse = try decoder.decode(NewsResponse.self, from:                          data)
//                        if let content = String(data: data, encoding: .utf8) {
//                            print(content)
//                        }
                        //代表大括號內容由main thread執行
                        
                        let currentDate = Date()
                        
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
                                                
                                                print(translateResponse)
                                                
                                                for i in translateResponse.indices{
                                                    if let ltitle = translateResponse[i].translations[0].text{
                                                        searchResponse.articles[i].lTitle=ltitle
                                                    }
                                                }
                                                
                                                let entryDate = Calendar.current.date(byAdding: .hour, value: 0, to: currentDate)!
                                                
                                                var entry = SimpleEntry(date: entryDate,newsTitle: [String](),newsUrl: [String]())
                                                for i in 0 ..< 5 {
                                                    
                                                    entry.newsTitle.append(translateResponse[i].translations[0].text!.components(separatedBy: "-").dropLast().joined(separator: "-"))
                                                    entry.newsUrl.append(searchResponse.articles[i].url)
                                                    
                                                }
                                                entries.append(entry)
                                            } catch  {
                                                print(error)
                                            }
                                            let timeline = Timeline(entries: entries, policy:  .after(currentDate.addingTimeInterval(60)))
                                            completion(timeline)
                                        }
                                    }.resume()

                                } catch  {
                                    print(error)
                                }
                            }
                        }.resume()

                    } catch {
                        print("News widget出問題",error)
                    }
                }
                
            }.resume()
        }
        
        // Generate a timeline consisting of five entries an hour apart, starting from the current date.
        

        
    }
}

struct SimpleEntry: TimelineEntry {
    let date: Date
    var newsTitle:[String]
    var newsUrl:[String]
}

struct newsWidgetEntryView : View {
    var entry: Provider.Entry
    @Environment(\.widgetFamily) var widgetFamily
    
    @AppStorage("widgetNewsTitle", store: UserDefaults(suiteName: "group.com.chouguting.weather_and_news_tw")) var widgetActionNewsTitle = ""
    
    var body: some View {
        switch widgetFamily{
        case.systemSmall:
            VStack{
                //Text(entry.date, style: .time)
                Text(entry.newsTitle[0]).padding()
            }.widgetURL(URL(string: entry.newsUrl[0])!)
        case .systemMedium:
            VStack{
                Text(entry.date, style: .time)
                Text(entry.newsTitle[0]).font(.title2).padding()
            }.widgetURL(URL(string: entry.newsUrl[0])!)
        case .systemLarge:
            VStack{
                Text(entry.date, style: .time)
                ForEach(entry.newsTitle.indices){
                    i in
                    if(i < 2){
//                        Text(entry.newsTitle[i]).font(.title2).padding()
                        Link(destination: URL(string: entry.newsUrl[i])!) {
                            Text(entry.newsTitle[i]).font(.title2).padding()
                        }
                    }
                }
                
               // Text(entry.newsTitle[1]).font(.title2).padding()
            }
        default:
            VStack{
                Text(entry.date, style: .time)
                Text("有\(entry.newsTitle.indices.endIndex)則新消息")
                HStack{
                    ForEach(entry.newsTitle.indices){
                        i in
                        if(i < 5){
    //                        Text(entry.newsTitle[i]).font(.title2).padding()
                            Link(destination: URL(string: entry.newsUrl[i])!) {
                                Text(entry.newsTitle[i]+"\n\n").font(.title2).padding().lineLimit(8)
                            }
                        }
                    }
                }
                
                
               // Text(entry.newsTitle[1]).font(.title2).padding()
            }
        }
        
    }
}

@main
struct newsWidget: Widget {
    let kind: String = "newsWidget"

    var body: some WidgetConfiguration {
        StaticConfiguration(kind: kind, provider: Provider()) { entry in
            newsWidgetEntryView(entry: entry)
        }
        .configurationDisplayName("My Widget")
        .description("This is an example widget.")
    }
}

struct newsWidget_Previews: PreviewProvider {
    static var previews: some View {
        newsWidgetEntryView(entry: SimpleEntry(date: Date(),newsTitle: ["AAAA"],newsUrl: ["www.google.com"]))
            .previewContext(WidgetPreviewContext(family: .systemSmall))
    }
}
