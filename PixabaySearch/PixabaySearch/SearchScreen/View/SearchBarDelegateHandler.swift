//
//  SearchBarDelegateHandler.swift
//  PixabaySearch
//
//  Created by Tushar Patil on 17/10/20.
//

import UIKit
import ReactiveCocoa

class SearchBarDelegateHandler: NSObject, UISearchBarDelegate {
    let viewModel: SearchViewModel
    
    init(viewModel: SearchViewModel) {
        self.viewModel = viewModel
    }
    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        print("Search Text ::\(String(describing: searchBar.text))")
        searchBar.endEditing(true)
    }
    
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        if searchText.isEmpty {
            viewModel.clearData()
        }
    }
}
