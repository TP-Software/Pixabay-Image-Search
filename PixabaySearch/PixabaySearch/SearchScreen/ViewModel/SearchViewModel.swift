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
    let shouldPaginate: MutableProperty<Bool> = MutableProperty<Bool>(false)
    let dataDao = SearchDataDao()
    var isRequestInProgress = false

    var totalHits: Int = 0
    var page: Int = 0
    var photos: [SearchCellViewModel] = []
    
    init() {
        NetworkManager.apiResponseType = .json
        setupBindings()
    }
    
    private func setupBindings() {
        searchText.producer
            .throttle(0.5, on: QueueScheduler())
            .filter { $0.isValid() }
            .startWithValues { [weak self] value in
                self?.reset()
                print("isValid = \(value.isValid())")
                self?.loadData(query: value)
            }
        
        shouldPaginate.producer
            .filter { $0 }
            .startWithValues { [weak self] _ in
                if let searchText: String = self?.searchText.value, searchText.isValid() {
                    self?.loadData(query: searchText)
                }
            }
    }
    
    func loadData(query: String) {
        guard !isRequestInProgress else {
            return
        }
        if totalHits == 0 || totalHits > photos.count {
            page += 1
            isRequestInProgress = true
            dataDao.requestData(page: page, query: query.trimmedText) { [weak self] result in
                switch result {
                case let .success(photosResponse):
                    self?.totalHits = photosResponse.totalHits
                    let dataArray = photosResponse.hits.compactMap { SearchCellViewModel(photo: $0) }
                    DispatchQueue.main.async { [weak self] in
                        if self?.page == 1 {
                            self?.photos = dataArray
                        } else {
                            self?.photos.append(contentsOf: dataArray)
                        }
                        self?.isDataLoaded.value = true
                    }
                case .none:
                    print("NONE")
                case let .failure(error):
                    print("FAILURE - \(error)")
                }
                DispatchQueue.main.async { [weak self] in
                    self?.isRequestInProgress = false
                    self?.shouldPaginate.value = false
                }
            }
        }
    }
    
    func clearData() {
        DispatchQueue.main.async { [weak self] in
            self?.dataDao.cancelRequest()
            self?.photos.forEach { $0.cancelRequest() }
            self?.photos = []
            self?.reset()
            self?.isDataLoaded.value = true
        }
    }
    
    func reset() {
        page = 0
        totalHits = 0
        isRequestInProgress = false
    }
}

private extension String {
    var trimmedText: String {
        trimmingCharacters(in: .whitespacesAndNewlines)
    }
    
    func isValid() -> Bool {
        return !self.trimmedText.isEmpty
    }
}
