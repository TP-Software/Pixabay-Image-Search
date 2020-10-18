//
//  SearchViewController.swift
//  PixabaySearch
//
//  Created by Tushar Patil on 17/10/20.
//

import UIKit
import ReactiveCocoa
import ReactiveSwift

class SearchViewController: UIViewController {

    @IBOutlet private var searchRecentsTableView: UITableView!
    @IBOutlet private var searchBarView: UISearchBar!
    @IBOutlet private var imagesCollectionView: UICollectionView!
    
    private let viewModel = SearchViewModel()
    private var imagesCollectionDelegateHandler: ImagesCollectionDelegateHandler?
    private var searchBarDelegateHandler: SearchBarDelegateHandler?
    private var searchRecentsDelegateHandler: SearchRecentsDelegateHandler?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        imagesCollectionDelegateHandler = ImagesCollectionDelegateHandler(viewModel: viewModel)
        searchBarDelegateHandler = SearchBarDelegateHandler(viewModel: viewModel)
        searchRecentsDelegateHandler = SearchRecentsDelegateHandler(viewModel: viewModel)
        
        imagesCollectionView.delegate = imagesCollectionDelegateHandler
        imagesCollectionView.dataSource = imagesCollectionDelegateHandler
        
        searchRecentsTableView.delegate = searchRecentsDelegateHandler
        searchRecentsTableView.dataSource = searchRecentsDelegateHandler
        
        searchBarView.delegate = searchBarDelegateHandler
        viewModel.searchText <~ searchBarView.searchTextField.reactive.continuousTextValues
        setupBindings()
    }
    
    private func setupBindings() {
        viewModel.isDataLoaded.producer
            .filter { $0 }
            .observe(on: UIScheduler())
            .startWithValues { [weak self] _ in
                if self?.viewModel.photos.isEmpty == false {
                    self?.displayImagesData()
                }
                self?.imagesCollectionView.reloadData()
            }
        
        viewModel.searchText.producer
            .filter { $0.isEmpty }
            .observe(on: UIScheduler())
            .startWithValues { [weak self] _ in
                self?.displayRecentsData()
            }
        
        searchBarView.reactive.textDidBeginEditing.producer
            .observe(on: UIScheduler())
            .startWithResult { [weak self] _ in
                self?.displayRecentsData()
            }
            
        searchBarView.reactive.textDidEndEditing.producer
            .observe(on: UIScheduler())
            .startWithResult { [weak self] _ in
                self?.displayImagesData()
            }
        
        searchRecentsDelegateHandler?.recentSelected.producer
            .filter { !$0.isEmpty }
            .observe(on: UIScheduler())
            .startWithValues { [weak self] selectedRecentSearch in
                self?.searchBarView.searchTextField.text = selectedRecentSearch
                self?.viewModel.searchText.value = selectedRecentSearch
                self?.searchBarView.searchTextField.resignFirstResponder()
                self?.displayImagesData()
            }
        
        imagesCollectionDelegateHandler?.selectedImageAtIndex.producer
            .filter { $0 != nil }
            .observe(on: UIScheduler())
            .startWithValues { [weak self] selectedIndex in
                if let strongSelf = self,
                   let detailsViewController = strongSelf.storyboard?.instantiateViewController(identifier: "DetailsViewController") as? DetailsViewController {
                    detailsViewController.cellViewModels = strongSelf.viewModel.photos
                    detailsViewController.selectedIndex = selectedIndex!
                    detailsViewController.modalTransitionStyle = .coverVertical
                    detailsViewController.modalPresentationStyle = .pageSheet
                    strongSelf.present(detailsViewController, animated: true, completion: nil)
                }
            }
    }
    
    private func displayImagesData() {
        imagesCollectionView.isHidden = false
        searchRecentsTableView.isHidden = true
        imagesCollectionView.reloadData()
    }
    
    private func displayRecentsData() {
        imagesCollectionView.isHidden = true
        searchRecentsTableView.isHidden = false
        searchRecentsTableView.reloadData()
    }
}
