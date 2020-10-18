//
//  DetailsViewController.swift
//  PixabaySearch
//
//  Created by Tushar Patil on 18/10/20.
//

import UIKit

class DetailsViewController: UIViewController {

    @IBOutlet var imageView: UIImageView!
    var cellViewModels: [SearchCellViewModel]!
    var selectedIndex: Int = 0
    
    override func viewDidLoad() {
        super.viewDidLoad()
        let leftSwipeGestureRecognizer = UISwipeGestureRecognizer(target: self, action: #selector(swipeLeft))
        leftSwipeGestureRecognizer.direction = .left

        let rightSwipeGestureRecognizer = UISwipeGestureRecognizer(target: self, action: #selector(swipeRight))
        rightSwipeGestureRecognizer.direction = .right
        
        imageView.addGestureRecognizer(leftSwipeGestureRecognizer)
        imageView.addGestureRecognizer(rightSwipeGestureRecognizer)
        
        displayImage()
    }
    
    @objc
    private func swipeRight() {
        if selectedIndex > 0 {
            selectedIndex -= 1
            UIView.transition(with: imageView,
                              duration: 0.75,
                              options: .transitionFlipFromLeft,
                              animations: { self.displayImage() },
                              completion: nil)
        }
    }
    
    @objc
    private func swipeLeft() {
        if cellViewModels.count - 1 > selectedIndex {
            selectedIndex += 1
            UIView.transition(with: imageView,
                              duration: 0.75,
                              options: .transitionFlipFromRight,
                              animations: { self.displayImage() },
                              completion: nil)
        }
    }
    
    private func displayImage() {
        let selectedCellViewModel = cellViewModels[selectedIndex]
        selectedCellViewModel.getImage(imageType: .large) { [weak self] image in
            DispatchQueue.main.async { [weak self] in
                self?.imageView.image = image
            }
            self?.preloadImages()
        }
    }
    
    private func preloadImages() {
        let preloadImageCount = 2
        let initialIndex = max(selectedIndex - preloadImageCount, 0)
        let endIndex = min(selectedIndex + preloadImageCount, cellViewModels.count - 1)
        
        for i in initialIndex...endIndex {
            let selectedCellViewModel = cellViewModels[i]
            selectedCellViewModel.getImage(imageType: .large) {_ in }
        }
    }
}
