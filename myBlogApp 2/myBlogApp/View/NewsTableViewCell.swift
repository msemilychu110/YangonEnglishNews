//
//  NewsTableViewCell.swift
//  myBlogApp
//
//  Created by Emily-Khine Chu on 10/22/18.
//  Copyright © 2018 Emily-Khine Chu. All rights reserved.
//

import UIKit

class NewsTableViewCell: UITableViewCell {
    
    @IBOutlet weak var headlineLabel: UILabel!
    
    @IBOutlet weak var newsImageView: UIImageView!
    var articleToDisplay: Article?
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        
        
    }
    
    func displayArticle(_ article:Article) {
        
        
        newsImageView.image = nil
        
        
        articleToDisplay = article
        
        
        headlineLabel.text = articleToDisplay?.title!
        
        
        
        let urlString = articleToDisplay?.urlToImage
        
        guard let urlString = urlString else {return}
        
        let cachedData = CacheManager.retrieveImageData(urlString)
        
        if cachedData != nil {
            
            guard let cacheData = cachedData else {return}
            newsImageView.image = UIImage(data: cacheData)
            return
        }
        
        
        let url = URL(string: urlString)
        
        
        guard let url = url else {
            print("Couldn't create url object")
            return
        }
        
        
        let session = URLSession.shared
        
        
        let dataTask = session.dataTask(with: url) { (data, response, error) in
            
            guard let data = data else {return}
            
            
            CacheManager.saveImageData(urlString, data)
            
            
            if self.articleToDisplay?.urlToImage == urlString {
                
                DispatchQueue.main.async {
                    self.newsImageView.image = UIImage(data: data)
                }
                
            }
            
        }
        
        
        dataTask.resume()
        
    }
    
}



