//
//  NetworkManager.swift
//  PixabaySearch
//
//  Created by Tushar Patil on 17/10/20.
//

import Foundation

final class NetworkManager {
    static var apiResponseType: ApiResponseType?
    private let apiHandler: IApiHandler?
    
    init?() {
        guard let type = NetworkManager.apiResponseType else {
            return nil
        }
        apiHandler = type == ApiResponseType.json ? JsonApiHandler() : nil
    }
    
    func requestData(page: Int, query: String, completion: @escaping (Result<PhotosResponse, Error>?) -> Void)  {
        apiHandler?.requestData(page: page, query: query, completion: completion)
    }
    
    func downloadImage(photoUrl: String, completion: @escaping (Result<Data, Error>?) -> Void)  {
        apiHandler?.downloadImage(photoUrl: photoUrl, completion: completion)
    }
    
    func cancelRequest() {
        apiHandler?.cancelRequest()
    }
}
