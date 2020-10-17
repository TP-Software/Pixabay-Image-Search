//
//  ImagesCollectionDelegateHandler.swift
//  PixabaySearch
//
//  Created by Tushar Patil on 17/10/20.
//

import UIKit

class ImagesCollectionDelegateHandler: NSObject, UICollectionViewDelegate, UICollectionViewDataSource {
    let viewModel: SearchViewModel
    
    init(viewModel: SearchViewModel) {
        self.viewModel = viewModel
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 0
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        UICollectionViewCell()
    }
    

}
