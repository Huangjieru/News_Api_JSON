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
    
    @IBOutlet weak var activityIndicator: UIActivityIndicatorView!
    
    //宣告變數建立NewsController物件
    var newsController = NewsController()
    //存入抓取到的API資料
    var newsArray:[Articles] = [Articles]()
    //加入searchbar
//    var searchController:UISearchController!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        title = "News"
        //loading資料
//        activityIndicator.alpha = 1
        activityIndicator.startAnimating()
        
        //表格代理
        tableView.delegate = self
        tableView.dataSource = self
        //搜尋代理
        searchBar.delegate = self
        searchBar.placeholder = "search news that you want."
        searchBar.showsCancelButton = true //顯示“取消”按鈕
        //抓資料
        fetchNews()
        refreshControl()
        
        //在navigation加入searchbar(也有cancel的按鈕)
//        searchController = UISearchController(searchResultsController: nil)
//        navigationItem.searchController = searchController
    
    }
    //抓新聞資料
    private func fetchNews(){
        newsController.fetchItems { news in
            if let news{
                DispatchQueue.main.async {
                    self.newsArray = news
                    self.tableView.reloadData()
                    //抓完資料Activity Indicator元件停止轉動
                    self.activityIndicator.stopAnimating()
                    self.activityIndicator.alpha = 0
                }
            }
        }
    }
    //更新資料與停止更新
    @objc func pullToRefresh(){
        fetchNews()
        tableView.refreshControl?.endRefreshing()
        
    }
    //更新
    func refreshControl(){
        tableView.refreshControl = UIRefreshControl()
        tableView.refreshControl?.addTarget(self, action: #selector(pullToRefresh), for: .valueChanged)
    }
    //將要呈現在tableView cell裡的資料另外寫成function
    func configure(cell:NewsTableViewCell,forItemAt indexPath: IndexPath){
        
        let news = newsArray[indexPath.row]
        cell.titleLabel.text = news.title
        cell.descriptionLabel.text = news.description
        cell.picImageView.image = UIImage(systemName: "newspaper.fill")
        if let newsImage = news.urlToImage {
            newsController.fetchImage(from: newsImage) { imagePic in
                if let image = imagePic{
                    DispatchQueue.main.async {
                        cell.picImageView.image = image
                    }
                }
            }
        }
        
        
        tableView.rowHeight = 180
        cell.titleLabel.font = UIFont.systemFont(ofSize: 25)
        cell.titleLabel.numberOfLines = 2
        
        cell.descriptionLabel.numberOfLines = 0
        
        cell.picImageView.layer.cornerRadius = 15
        cell.picImageView.contentMode = .scaleAspectFill
        
    }
    
}


// MARK: - Table view data source
extension NewsViewController: UITableViewDelegate, UITableViewDataSource{
    
    //沒有override複寫
    func numberOfSections(in tableView: UITableView) -> Int {
        
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return newsArray.count
        
    }
    
    //資訊顯示於表格上
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: NewsTableViewCell.reuseIdentifier, for: indexPath) as! NewsTableViewCell
       //呼叫configure function呈現資料
       configure(cell: cell, forItemAt: indexPath)
        
        return cell
        
    }
    
    //點選cell連線到新聞頁面
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        if let newsDetail = newsArray[indexPath.row].url{
            let safariViewController = SFSafariViewController(url: newsDetail)
            present(safariViewController, animated: true)
           
        }
        
    }
    
}
extension NewsViewController: UISearchBarDelegate{
    
    func fetchSearchNews(){
        newsController.fetchSearchNews(text: searchBar.text ?? "") { news in
            if let news{
                DispatchQueue.main.async {
                    self.newsArray = news
                    self.tableView.reloadData()
                }
            }
        }
    }
    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {

        self.newsArray = []
        
        fetchSearchNews()
        refreshSearchController()
        
        view.endEditing(true)
    }
    
    //下拉更新重新抓艘尋的茲料
    @objc private func pullSearchToRefresh(){
        fetchSearchNews()
        tableView.refreshControl?.endRefreshing()
    }
    //更新搜尋的新聞內容
   private func refreshSearchController(){
        tableView.refreshControl = UIRefreshControl()
        tableView.refreshControl?.addTarget(self, action: #selector(pullSearchToRefresh), for: .valueChanged)
    }
    //searchBar按cancel按鈕
    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
        searchBar.text = ""
        searchBar.endEditing(true)
        //清除陣列裡的資料
        newsArray.removeAll()
        //下方重新抓取資料並顯示
        fetchNews()
        tableView.reloadData()
    }
   
}


