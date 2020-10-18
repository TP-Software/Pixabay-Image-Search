//
//  ImageCollectionViewCell.swift
//  PixabaySearch
//
//  Created by Tushar Patil on 17/10/20.
//

import UIKit

class ImageCollectionViewCell: UICollectionViewCell {
    @IBOutlet private var imageView: UIImageView!
    
    override func prepareForReuse() {
        imageView.image = nil
    }
    
    func configureCell(cellViewModel: SearchCellViewModel) {
        cellViewModel.getImage(imageType: .preview) { image in
            DispatchQueue.main.async { [weak self] in
                self?.imageView.image = image
            }
        }
    }
    
    deinit {
        print("Deinit :: ImageCollectionViewCell")
    }
}
