//
//  SearchDataDao.swift
//  PixabaySearch
//
//  Created by Tushar Patil on 17/10/20.
//

protocol ISearchDao {
    func requestData(page: Int, query: String, completion: @escaping (Result<PhotosResponse, Error>?) -> Void)
    func cancelRequest()
}

final class SearchDataDao {
    static var externalDao: ISearchDao?
    private let dataDao: ISearchDao
    
    init() {
        dataDao = SearchDataDao.externalDao ?? SearchNetworkDao()
    }
    
    func requestData(page: Int, query: String, completion: @escaping (Result<PhotosResponse, Error>?) -> Void) {
        dataDao.requestData(page: page, query: query, completion: completion)
    }
    
    func cancelRequest() {
        dataDao.cancelRequest()
    }
    
    deinit {
        print("Deinit :: SearchDataDao")
    }
}
