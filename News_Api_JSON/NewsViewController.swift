//
//  NewsViewController.swift
//  News_Api_JSON
//
//  Created by jr on 2022/10/6.
//

import UIKit
import SafariServices
import Kingfisher
//加入UITableViewDelegate,UITableViewDataSource 協定
class NewsViewController:UIViewController {
    
    
    @IBOutlet weak var searchBar: UISearchBar!
    @IBOutlet weak var tableView: UITableView!
    
    var newsArray:[Articles] = [Articles]()
    
    var searchNewsArray = [Articles]()
    var searching = false
    
    override func viewDidLoad() {
        super.viewDidLoad()
        //表格代理
        tableView.delegate = self
        tableView.dataSource = self
        //搜尋代理
        searchBar.delegate = self
        searchBar.placeholder = "search news that you want."

            fetchNews()
    
    }
    
    func fetchNews(){
        
        if let url = URL(string: "https://newsapi.org/v2/top-headlines?country=us&category=business&apiKey=60ee7c4a0986431ba48c8d9f5a9efa4f"){
            URLSession.shared.dataTask(with: url) {
                data, response, error
                in
                if let data = data{
                    let decoder = JSONDecoder()
                    do{
                       let news = try decoder.decode(News.self, from: data)
                        self.newsArray = news.articles
                        DispatchQueue.main.async {
                            self.tableView.reloadData()
                        }
                        
                    }catch{
                        print(error)
                    }
                    
                }
            }.resume()
        }
        
    }
    
}

// MARK: - Table view data source
extension NewsViewController: UITableViewDelegate, UITableViewDataSource{
    
    //沒有override複寫
    func numberOfSections(in tableView: UITableView) -> Int {
        
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        if searching{
            print("數量:\(searchNewsArray.count)")
            return searchNewsArray.count
        }else{
            return newsArray.count
        }
        
    }
    
    //資訊顯示於表格上
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "\(NewsTableViewCell.self)", for: indexPath) as! NewsTableViewCell
        
        
        if searching{
            let searchNews = searchNewsArray[indexPath.row]
            cell.titleLabel.text = searchNews.title
            print("searching_title:\(cell.titleLabel.text)")
            cell.descriptionLabel.text = searchNews.description
            print("searching_desc:\(cell.descriptionLabel.text)")
            
            if let newsImage = searchNews.urlToImage{
                URLSession.shared.dataTask(with: newsImage) { data, response, error in
                    if let data = data, let image = UIImage(data: data)
                    {

                        DispatchQueue.main.async {
                            cell.picImageView.image = image

                        }
                    }
                }.resume()
            }
            
        }else{
            
                let news = newsArray[indexPath.row]
                
                cell.titleLabel.text = news.title
                cell.descriptionLabel.text = news.description
                
                
                //<方法一>清空圖片,才不會因為 cell 重覆利用而顯示舊的照片
                //        cell.picImageView.image = nil
                //<方法二>顯示預設圖片，才不會因為cell重複利用而顯示舊的照片
                //        cell.picImageView.image = UIImage(systemName: "newspaper.fill")
                
                //要滑動後才會顯示圖片->解法：用自訂的 cell 樣式,不要用內建的 cell 樣式。給cell Id
//                        cell.picImageView.kf.setImage(with: news.urlToImage, placeholder: UIImage(systemName: "newspaper.fill"))
                
                if let newsURL = news.urlToImage{
                    URLSession.shared.dataTask(with: newsURL) { data, respones, error in
                        if let data = data{
                           
                            DispatchQueue.main.async {
                                cell.picImageView.image = UIImage(data: data)
                                
                            }
                            
                        }
                    }.resume()
                }
        }//else
        
        
        tableView.rowHeight = 180
        cell.titleLabel.font = UIFont.systemFont(ofSize: 25)
        cell.titleLabel.numberOfLines = 2
        
        cell.descriptionLabel.numberOfLines = 0
        
        cell.picImageView.layer.cornerRadius = 15
        cell.picImageView.contentMode = .scaleAspectFill
        
        return cell
        
    }
    
    //點選cell連線到新聞頁面
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        if searching{
            if let searchNewsDetail = searchNewsArray[indexPath.row].url{
                let safariViewController = SFSafariViewController(url: searchNewsDetail)
                present(safariViewController, animated: true)
            }
        }else{
            
            if let newsDetial = newsArray[indexPath.row].url{
                let safariViewController = SFSafariViewController(url: newsDetial)
                present(safariViewController, animated: true)
            }
        }
        
    }
    
}
extension NewsViewController: UISearchBarDelegate{
    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        
        searching = true
        searchNews(text: searchBar.text ?? "")
        view.endEditing(true)
    }
     
    func searchNews(text:String){
         //searchin?=title=\()
        let urlString = "https://newsapi.org/v2/everything?domains=wsj.com&apiKey=60ee7c4a0986431ba48c8d9f5a9efa4f&searchIn=title&q=\(text)"
         if let url = URL(string: urlString.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed)!){
             let task = URLSession.shared.dataTask(with: url) {
                 data, response, error
                 in
                 if let data = data{
                     let decoder = JSONDecoder()
                     do{
                         let news = try decoder.decode(News.self, from: data)
                         self.searchNewsArray = news.articles
                         DispatchQueue.main.async {
                             self.tableView.reloadData()
                         }
                     }catch{
                         print(error)
                     }
                     
                 }
             }
             task.resume()
         }
     }
   
}
