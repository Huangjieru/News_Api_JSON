//
//  NewsController.swift
//  News_Api_JSON
//
//  Created by jr on 2022/10/23.
//

import Foundation
import UIKit

class NewsController{
    //畫面出現時呈現的新聞
    func fetchItems(completion:@escaping ([Articles]?)->Void){
        guard let urlString = "https://newsapi.org/v2/top-headlines?country=us&category=business&apiKey=60ee7c4a0986431ba48c8d9f5a9efa4f".addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed), let url = URL(string: urlString) else {
            completion(nil)
            return}
        URLSession.shared.dataTask(with: url) { data, response, error in
            if let _ = error{
                completion(nil)
            }else if let data = data{
                do{
                    let decoder = JSONDecoder()
                    let news = try decoder.decode(News.self, from: data)
                    completion(news.articles)
                }catch{
                    print(error)
                    completion(nil)
                }
            }
        }.resume()
    }
    //抓取新聞圖片
    func fetchImage(from url: URL, completion: @escaping (UIImage?)->Void){
        URLSession.shared.dataTask(with: url) { data, response, error in
            if let _ = error{
                completion(nil)
            }else if let data = data, let image = UIImage(data: data){
                completion(image)
            }else{
                completion(nil)
            }
        }.resume()
    }
    //搜尋新聞的API
    func fetchSearchNews(text:String, completion:@escaping ([Articles]?)->Void){
        guard let urlString = "https://newsapi.org/v2/everything?domains=wsj.com&apiKey=60ee7c4a0986431ba48c8d9f5a9efa4f&searchIn=title&q=\(text)".addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed), let url = URL(string: urlString)  else { return}
        URLSession.shared.dataTask(with: url) { data, response, error in
            if let data = data{
                do{
                   let deocoder = JSONDecoder()
                  let news = try deocoder.decode(News.self, from: data)
                    completion(news.articles)
                }catch{
                    print(error)
                }
            }
        }.resume()
    }
    
    
}
