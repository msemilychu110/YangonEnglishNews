//
//  ArticleService.swift
//  myBlogApp
//
//  Created by Emily-Khine Chu on 10/26/18.
//  Copyright © 2018 Emily-Khine Chu. All rights reserved.
//

import Foundation

struct Article : Decodable {
    
    var author:String?
    var title:String?
    var description:String?
    var url:String?
    var urlToImage:String?
    var publishedAt:String?
    
}
