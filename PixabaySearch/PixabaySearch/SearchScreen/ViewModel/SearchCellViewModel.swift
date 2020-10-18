//
//  SearchCellViewModel.swift
//  PixabaySearch
//
//  Created by Tushar Patil on 17/10/20.
//
import UIKit

enum ImageType {
    case preview
    case large
}

final class SearchCellViewModel {
    private let photo: Photo
    private let imageLoader = ImageLoader()
    
    init(photo: Photo) {
        self.photo = photo
    }
    
    func getImage(imageType: ImageType, closure: @escaping ((UIImage) -> Void)) {
        let photoUrl = imageType == .preview ? photo.previewURL : photo.largeImageURL
        imageLoader.loadImage(photoUrl: photoUrl, closure: closure)
    }

    func cancelRequest() {
        imageLoader.cancelRequest()
    }
    
    deinit {
        print("Deinit :: SearchCellViewModel")
    }
}
