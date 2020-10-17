//
//  SearchCellViewModel.swift
//  PixabaySearch
//
//  Created by Tushar Patil on 17/10/20.
//
import UIKit

final class SearchCellViewModel {
    private let photo: Photo
    private let imageLoader = ImageLoader()
    
    init(photo: Photo) {
        self.photo = photo
    }
    
    func getImage(closure: @escaping ((UIImage) -> Void)) {
        imageLoader.loadImage(photoUrl: photo.previewURL, closure: closure)
    }

    func cancelRequest() {
        imageLoader.cancelRequest()
    }
    
    deinit {
        print("Deinit :: SearchCellViewModel")
    }
}
