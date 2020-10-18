//
//  DetailsViewModel.swift
//  PixabaySearch
//
//  Created by Tushar Patil on 18/10/20.
//

import UIKit

class DetailsViewModel {
    let cellViewModels: [SearchCellViewModel]
    var selectedIndex: Int
    
    init(cellViewModels: [SearchCellViewModel], index: Int) {
        self.cellViewModels = cellViewModels
        selectedIndex = index
    }
    
    
    func getSelectedIndex() -> Int {
        selectedIndex
    }
    
    func setSelectedIndex(index: Int) {
        selectedIndex = index
    }
    
    func getSelectedCellViewModel() -> SearchCellViewModel {
        cellViewModels[selectedIndex]
    }
    
    func decrementSelectedIndex()  {
        selectedIndex -= 1
    }
    
    func incrementSelectedIndex()  {
        selectedIndex += 1
    }
    
    func isFirstImageDisplayed() -> Bool {
        selectedIndex == 0
    }
    
    func isLastImageDisplayed() -> Bool {
        selectedIndex == cellViewModels.count - 1
    }
    
    func preloadImages() {
        let preloadImageCount = 2
        let initialIndex = max(selectedIndex - preloadImageCount, 0)
        let endIndex = min(selectedIndex + preloadImageCount, cellViewModels.count - 1)
        
        for index in initialIndex...endIndex {
            let selectedCellViewModel = cellViewModels[index]
            selectedCellViewModel.getImage(imageType: .large) { _ in }
        }
    }
}
