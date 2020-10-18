//
//  NSCacheManager.swift
//  PixabaySearch
//
//  Created by Tushar Patil on 18/10/20.
//

import UIKit

final class NSCacheManager: ImageStorage {
    let cache = NSCache<NSString, UIImage>()
    static var sharedInstance = NSCacheManager()
    
    private init() {
        cache.countLimit = 500
        cache.totalCostLimit = 25 * 1024 * 1024
    }
    
    //Need to move to extension
    func add(imageUrl: String, image: UIImage) {
        cache.setObject(image, forKey: imageUrl as NSString)
    }
    
    func get(imageUrl: String) -> UIImage? {
        cache.object(forKey: imageUrl as NSString)
    }
}
