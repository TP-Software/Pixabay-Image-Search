//
//  ImageLoader.swift
//  PixabaySearch
//
//  Created by Tushar Patil on 17/10/20.
//
import UIKit

final class ImageLoader {
    var networkManager: NetworkManager?
    
    func loadImage(photoUrl: String, closure: @escaping ((UIImage) -> Void)) {
        if let image = ImageStorageManager.get(imageUrl: photoUrl) {
            print("ImageLoader :: Used from cache for url = \(photoUrl)")
            closure(image)
        } else {
            networkManager = NetworkManager()
            networkManager!.downloadImage(photoUrl: photoUrl) { result in
                switch result {
                case let .success(data):
                    if let uiImage = UIImage(data: data) {
                        closure(uiImage)
                        ImageStorageManager.add(imageUrl: photoUrl, image: uiImage)
                        print("ImageLoader :: Downloaded from server for url = \(photoUrl)")
                        return
                    }
                default:
                    print("default: getImage()")
                }
                print("ImageLoader :: Used placeholder image for url = \(photoUrl)")
                closure(UIImage(named: "placeholder")!)
            }
        }
    }
    
    func cancelRequest() {
        networkManager?.cancelRequest()
    }
    
    deinit {
        print("Deinit :: ImageLoader")
    }
}
