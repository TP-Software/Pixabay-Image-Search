//
//  ImagesCollectionDelegateHandler.swift
//  PixabaySearch
//
//  Created by Tushar Patil on 17/10/20.
//

import UIKit
import ReactiveSwift

class ImagesCollectionDelegateHandler: NSObject, UICollectionViewDelegate, UICollectionViewDataSource {
    let viewModel: SearchViewModel
    let selectedImageAtIndex: MutableProperty<Int?> = MutableProperty<Int?>(nil)
    
    init(viewModel: SearchViewModel) {
        self.viewModel = viewModel
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        viewModel.photos.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "ImageCollectionViewCell", for: indexPath) as! ImageCollectionViewCell
         cell.configureCell(cellViewModel: viewModel.photos[indexPath.row])
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        selectedImageAtIndex.value = indexPath.row
    }
}

extension ImagesCollectionDelegateHandler: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let isIpad = UIDevice.current.userInterfaceIdiom == .pad
        let cellSpacing = isIpad ? 50 : 20
        let width = CGFloat((Int(collectionView.bounds.size.width) - cellSpacing) / (isIpad ? 6 : 3))
        return CGSize(width: width, height: width)
    }
}

extension ImagesCollectionDelegateHandler: UIScrollViewDelegate {
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        if viewModel.shouldPaginate.value == false, (scrollView.contentOffset.y + scrollView.frame.size.height) >= (scrollView.contentSize.height * (2/3)) {
            viewModel.shouldPaginate.value = true
        }
    }
}
