//
//  NewsResponse.swift
//  weather_and_news_tw
//
//  Created by 周固廷 on 2021/12/12.
//

import Foundation

struct NewsResponse: Codable {
    let status:String?
    let totalResults:Int?
    let articles:[Article]
    
}

struct Article:Codable,Identifiable{
    var id: String{url}
    let author:String?
    let title:String
    let description:String?
    let url:String
    let urlToImage:String?
    let publishedAt:String?
}

