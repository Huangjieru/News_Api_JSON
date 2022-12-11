//
//  NewsController.swift
//  News_Api_JSON
//
//  Created by jr on 2022/10/23.
//

import Foundation
import UIKit

class NewsController{
    
    static let shared = NewsController()
    //產生 NSCache 物件。以key找對應的value。<>裡傳入key, value。key的型別是NSURL, value的型別是UIImage。
    let imageCache = NSCache<NSURL, UIImage>()
    //NSCache 要求它的 key & value 的型別都必須是物件，因此只能傳入 class 定義的型別，而 URL 是 struct。
    //NSCache 比較不會造成記憶體的問題，因為當系統記憶體不夠時，它會自動將東西從 cache 裡移除
    
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
        //當 cache 有圖時，直接讀取 cache 裡的圖片
        if let image = imageCache.object(forKey: url as NSURL){
            print("抓Cache圖片")
            completion(image)
        }
        URLSession.shared.dataTask(with: url) { data, response, error in
            if let _ = error{
                completion(nil)
            }else if let data = data, let image = UIImage(data: data){
                //從網路抓圖後，將圖片存入 cache。setObject(_:forKey:)，將圖片存入 cache
                self.imageCache.setObject(image, forKey: url as NSURL) //在產生 imageCache 設定時是 NSURL，所以在此要做型別的轉換，將url利用 as 轉成 NSURL。
                
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
