//
//  ImageStorageManager.swift
//  PixabaySearch
//
//  Created by Tushar Patil on 17/10/20.
//

import Foundation
import UIKit

enum StorageType {
    case nsCache
    case sqlite
    case coreData
    case fmdb
}

protocol ImageStorage {
    func add(imageUrl: String, image: UIImage)
    func get(imageUrl: String) -> UIImage?
}

class ImageStorageManager {
    static var storageType: StorageType?
    private static let sharedInstance = ImageStorageManager()
    private let imageStorage: ImageStorage?
    
    private init?() {
        guard let type = ImageStorageManager.storageType else {
            return nil
        }
        imageStorage = type == StorageType.nsCache ? NSCacheManager.sharedInstance : nil
    }

    static func add(imageUrl: String, image: UIImage) {
        sharedInstance?.imageStorage?.add(imageUrl: imageUrl, image: image)
    }
    
    static func get(imageUrl: String) -> UIImage? {
        sharedInstance?.imageStorage?.get(imageUrl: imageUrl)
    }
}

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
