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
    
    @IBOutlet weak var dateLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
