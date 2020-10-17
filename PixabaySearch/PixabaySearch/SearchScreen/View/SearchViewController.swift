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

    @IBOutlet private var searchBarView: UISearchBar!
    @IBOutlet private var imagesCollectionView: UICollectionView!
    private let viewModel = SearchViewModel()
    private var imagesCollectionDelegateHandler: ImagesCollectionDelegateHandler?
    private var searchBarDelegateHandler: SearchBarDelegateHandler?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        imagesCollectionDelegateHandler = ImagesCollectionDelegateHandler(viewModel: viewModel)
        searchBarDelegateHandler = SearchBarDelegateHandler(viewModel: viewModel)
        
        imagesCollectionView.delegate = imagesCollectionDelegateHandler
        imagesCollectionView.dataSource = imagesCollectionDelegateHandler
        
        searchBarView.delegate = searchBarDelegateHandler
        viewModel.searchText <~ searchBarView.searchTextField.reactive.continuousTextValues
    }


}

