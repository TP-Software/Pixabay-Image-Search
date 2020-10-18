//
//  SearchViewModel.swift
//  PixabaySearch
//
//  Created by Tushar Patil on 17/10/20.
//

import Foundation
import ReactiveSwift

final class SearchViewModel {
    //Mutable Properties
    let isDataLoaded: MutableProperty<Bool> = MutableProperty<Bool>(false)
    let searchText: MutableProperty<String> = MutableProperty<String>("")
    let shouldPaginate: MutableProperty<Bool> = MutableProperty<Bool>(false)
    let isEmptyResponse: MutableProperty<Bool> = MutableProperty<Bool>(false)
    
    private let dataDao = SearchDataDao()
    private var isRequestInProgress = false
    private var totalHits: Int = 0
    private var page: Int = 0
    var photos: [SearchCellViewModel] = []
    var searchRecents: CustomArray<String> = CustomArray<String>(maxSize: 10)
    
    private static let SearchRecentListKey = "SearchRecentList"
    
    init() {
        setupBindings()
        if let recentList = UserDefaults.standard.getObject(forKey: SearchViewModel.SearchRecentListKey, castTo: CustomArray<String>.self) {
            searchRecents = recentList
        }
    }
    
    private func setupBindings() {
        searchText.producer
            .throttle(1, on: QueueScheduler())
            .skipRepeats()
            .filter { $0.isValid() }
            .startWithValues { [weak self] value in
                self?.reset()
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
    
    private func loadData(query: String) {
        guard !isRequestInProgress else {
            return
        }
        if totalHits == 0 || totalHits > photos.count {
            page += 1
            isRequestInProgress = true
            dataDao.requestData(page: page, query: query.trimmedText) { [weak self] result in
                switch result {
                case let .success(photosResponse):
                    self?.handleSuccessResponse(query: query, photosResponse: photosResponse)
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
    
    private func handleSuccessResponse(query: String, photosResponse: PhotosResponse) {
        totalHits = photosResponse.totalHits
        let dataArray = photosResponse.hits.compactMap { SearchCellViewModel(photo: $0) }
        DispatchQueue.main.async { [weak self] in
            if let strongSelf = self {
                if strongSelf.page == 1 {
                    strongSelf.photos = dataArray
                    strongSelf.isEmptyResponse.value = dataArray.isEmpty
                } else {
                    strongSelf.photos.append(contentsOf: dataArray)
                }
                strongSelf.isDataLoaded.value = true
                if !strongSelf.isEmptyResponse.value {
                    strongSelf.searchRecents.insert(element: query)
                }
                UserDefaults.standard.setObject(self?.searchRecents, forKey: SearchViewModel.SearchRecentListKey)
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
    
    private func reset() {
        page = 0
        totalHits = 0
        isRequestInProgress = false
    }
}
