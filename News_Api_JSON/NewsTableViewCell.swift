//
//  NewsTableViewCell.swift
//  News_Api_JSON
//
//  Created by jr on 2022/10/2.
//

import UIKit

class NewsTableViewCell: UITableViewCell {
    


    @IBOutlet weak var picImageView: UIImageView!
    
    @IBOutlet weak var titleLabel: UILabel!
    
    @IBOutlet weak var descriptionLabel: UILabel!
    
    @IBOutlet weak var content: UILabel!
    
    var articles:Articles!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    //將要呈現在tableView cell裡的資料另外寫成function
    func configure(with articles: Articles){
        
        self.articles = articles
        titleLabel.text = articles.title
        descriptionLabel.text = articles.description
        picImageView.image = UIImage(systemName: "newspaper.fill")
        if let newsImage = articles.urlToImage {
            NewsController.shared.fetchImage(from: newsImage) { imagePic in
                if let image = imagePic{
                    DispatchQueue.main.async {
                        self.picImageView.image = image
                    }
                }
            }
        }
        titleLabel.font = UIFont.systemFont(ofSize: 25)
        titleLabel.numberOfLines = 2
        
        descriptionLabel.numberOfLines = 0
        
        picImageView.layer.cornerRadius = 15
        picImageView.contentMode = .scaleAspectFill
        
    }
    
}


