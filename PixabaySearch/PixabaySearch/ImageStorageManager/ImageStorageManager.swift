//
//  ImageStorageManager.swift
//  PixabaySearch
//
//  Created by Tushar Patil on 17/10/20.
//

import UIKit

final class ImageStorageManager {
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
