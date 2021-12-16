//
//  NewsSearchResponse.swift
//  weather_and_news_tw
//
//  Created by 周固廷 on 2021/12/12.
//

import Foundation

struct NewsSearchResponse:Codable{
    let _type:String
    let readLink:String?
    let value:[SearchedNews]
}

struct SearchedNews:Codable,Identifiable{
    var id:String{url}
    let name:String
    let url:String
    let image:ImageThumbnail?
    let description:String
    let provider:ProviderInfo
    let datePublished:String
    
}

struct ImageThumbnail:Codable{
    let thumbnail:Thumbnail
}

struct Thumbnail:Codable{
    let contentUrl:String
}

struct ProviderInfo:Codable{
    
}
