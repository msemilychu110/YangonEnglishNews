//
//  CacheManager.swift
//  myBlogApp
//
//  Created by Emily-Khine Chu on 10/27/18.
//  Copyright © 2018 Emily-Khine Chu. All rights reserved.
//

import Foundation
class CacheManager {
    
    static var imageDictionary = [String:Data]()
    
    static func saveImageData(_ url:String, _ data:Data) {
        
        
        imageDictionary[url] = data
        
    }
    
    static func retrieveImageData(_ url:String) -> Data? {
        
        return imageDictionary[url]
    }
    
}
