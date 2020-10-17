//
//  SearchViewModel.swift
//  PixabaySearch
//
//  Created by Tushar Patil on 17/10/20.
//

import Foundation
import ReactiveSwift

class SearchViewModel {
    let isDataLoaded: MutableProperty<Bool> = MutableProperty<Bool>(false)
    let searchText: MutableProperty<String> = MutableProperty<String>("")
    
    init() {
        setupBindings()
    }
    
    private func setupBindings() {
        searchText.producer
            .throttle(0.5, on: QueueScheduler())
            .filter { !$0.isEmpty}
            .startWithValues { value in
                print(value)
            }
    }
}
