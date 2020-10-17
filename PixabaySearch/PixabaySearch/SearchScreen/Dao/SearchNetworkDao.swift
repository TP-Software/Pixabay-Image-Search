//
//  SearchNetworkDao.swift
//  PixabaySearch
//
//  Created by Tushar Patil on 17/10/20.
//

final class SearchNetworkDao: ISearchDao {
    var networkManager: NetworkManager?
    
    func requestData(page: Int, query: String, completion: @escaping (Result<PhotosResponse, Error>?) -> Void) {
        networkManager = NetworkManager()
        networkManager?.requestData(page: page, query: query, completion: completion)
    }
    
    func cancelRequest() {
        networkManager?.cancelRequest()
        networkManager = nil
    }
    
    deinit {
        print("Deinit :: SearchNetworkDao")
    }
}
