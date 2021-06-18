//
//  ArticleModel.swift
//  myBlogApp
//
//  Created by Emily-Khine Chu on 10/27/18.
//  Copyright © 2018 Emily-Khine Chu. All rights reserved.
//

import Foundation
protocol ArticleModelProtocol {
    func articlesRetrieved(_ articles: [Article])
}

class ArticleModel {
    
    var delegate: ArticleModelProtocol?
    
    func getArticles() {
        
        let stringUrl = "https://newsapi.org/v2/top-headlines?country=us&apiKey=c27885e563c34e079a3c6b614babc7d6"
        
        let url = URL(string: stringUrl)
        guard url != nil else {
            print("couldn't find url object")
            return
        }
        let session = URLSession.shared
        let dataTask = session.dataTask(with: url!) { (data, response, error) in
            guard error == nil && data != nil else {return}
            if let data = data {
                do {
                    let decoder = JSONDecoder()
                    let result = try decoder.decode(ArticleService.self, from: data)
                    let articles = result.articles
                    DispatchQueue.main.async {
                        if let
                            articles = articles { self.delegate?.articlesRetrieved(articles)}
                    }
                    
                }
                catch {
                    
                    print("Couldn't decode the json")
                    return
                }
            }
            
        }
        dataTask.resume()
        
    }
    
}
