//
//  News.swift
//  News_Api_JSONTests
//
//  Created by jr on 2022/10/2.
//

import Foundation

struct News:Decodable{
    let articles:[Articles]
}
//印出錯誤訊息加上Optional的?
struct Articles:Decodable{
    let title:String?
    let description:String?
    let url:URL?
    let urlToImage:URL?
    let publishedAt:String?
    let content:String?
}

//class SearchNews{
//    static var shareNewsData = [Articles]()
//}
