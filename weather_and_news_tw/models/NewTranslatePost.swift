//
//  NewTranslatePost.swift
//  weather_and_news_tw
//
//  Created by 周固廷 on 2022/1/12.
//

import Foundation

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
