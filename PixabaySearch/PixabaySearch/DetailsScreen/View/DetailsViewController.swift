//
//  DetailsViewController.swift
//  PixabaySearch
//
//  Created by Tushar Patil on 18/10/20.
//

import UIKit

final class DetailsViewController: UIViewController {

    @IBOutlet private var loadingView: UIActivityIndicatorView!
    @IBOutlet private var imageView: UIImageView!
    var viewModel: DetailsViewModel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        addGestureRecognizer()
        displayImage()
    }
    
    private func addGestureRecognizer() {
        let leftSwipeGestureRecognizer = UISwipeGestureRecognizer(target: self, action: #selector(displayNextImage))
        leftSwipeGestureRecognizer.direction = .left

        let rightSwipeGestureRecognizer = UISwipeGestureRecognizer(target: self, action: #selector(displayPreviousImage))
        rightSwipeGestureRecognizer.direction = .right
        
        imageView.addGestureRecognizer(leftSwipeGestureRecognizer)
        imageView.addGestureRecognizer(rightSwipeGestureRecognizer)
    }
    
    @objc
    private func displayPreviousImage() {
        if !viewModel.isFirstImageDisplayed() {
            viewModel.decrementSelectedIndex()
            UIView.transition(with: imageView,
                              duration: 0.75,
                              options: .transitionFlipFromLeft,
                              animations: { [weak self] in self?.displayImage() },
                              completion: nil)
        }
    }
    
    @objc
    private func displayNextImage() {
        if !viewModel.isLastImageDisplayed() {
            viewModel.incrementSelectedIndex()
            UIView.transition(with: imageView,
                              duration: 0.75,
                              options: .transitionFlipFromRight,
                              animations: { [weak self] in self?.displayImage() },
                              completion: nil)
        }
    }
    
    private func displayImage() {
        imageView.image = nil
        loadingView.startAnimating()
        viewModel.getSelectedCellViewModel().getImage(imageType: .large) { [weak self] image in
            DispatchQueue.main.async { [weak self] in
                self?.imageView.image = image
                self?.loadingView.stopAnimating()
            }
            self?.viewModel.preloadImages()
        }
    }
}
