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

}
