//
//  NetworkManager.swift
//  PixabaySearch
//
//  Created by Tushar Patil on 17/10/20.
//

import Foundation

enum ApiResponseType {
    case json
    case xml
}

protocol IApiHandler {
    func requestData(page: Int, query: String, completion: @escaping (Result<PhotosResponse, Error>?) -> Void)
    func downloadImage(photoUrl: String, completion: @escaping (Result<Data, Error>?) -> Void)
    func cancelRequest()
}

class JsonApiHandler: IApiHandler {
    private var task: URLSessionTask?
    private var isCancelled = false
    
    enum RequestUrl {
        private static let ApiKey: String = "18733249-64b3f4574ceffbd2cc4399aab"
        
        case imagesData(page: Int, query: String)
        case imageDownload(url: String)
        
        var url: URL? {
            switch self {
            case let .imagesData(page, query):
                let query = query.addingPercentEncoding(withAllowedCharacters: .alphanumerics) ?? query
                return URL(string: "https://pixabay.com/api/?key=\(RequestUrl.ApiKey)&q=\(query)&image_type=photo&page=\(page)&per_page=\(48)")
                
            case let .imageDownload(url):
                return URL(string: url)
            }
        }
    }
    
    func requestData(page: Int, query: String, completion: @escaping (Result<PhotosResponse, Error>?) -> Void)  {
        let urlSession = URLSession.shared
        guard let url = RequestUrl.imagesData(page: page, query: query).url else {
            completion(Result.failure(NSError(domain: "Empty Query/Url not found", code: 1, userInfo: nil)))
            return
        }
        DispatchQueue.global(qos: .userInitiated).async { [weak self] in
            self?.task = urlSession.dataTask(with: url) { [weak self] data, _, error in
                guard self?.isCancelled == false else {
                    print("ApiRequestManager :: requestData :: request cancelled for data url = \(url.absoluteString)")
                    return
                }
                print("ApiRequestManager :: requestData :: request active for data url = \(url.absoluteString)")
                guard let data = data else {
                    completion(Result.failure(NSError(domain: error.debugDescription, code: 2, userInfo: nil)))
                    return
                }
                print("Data: \(String(describing: String(data: data, encoding: .utf8)))")
                guard let photos = try? JSONDecoder().decode(PhotosResponse.self, from: data) else {
                    completion(.none)
                    return
                }
                completion(.success(photos))
            }
            print("ApiRequestManager :: requestData :: Starting request for data url = \(url.absoluteString)")
            self?.task?.resume()
        }
    }
    
    func downloadImage(photoUrl: String, completion: @escaping (Result<Data, Error>?) -> Void)  {
        let urlSession = URLSession.shared
        
        guard let url = RequestUrl.imageDownload(url: photoUrl).url else {
            completion(Result.failure(NSError(domain: "Url not found", code: 1, userInfo: nil)))
            return
        }
        
        DispatchQueue.global(qos: .userInteractive).async { [weak self] in
            self?.task = urlSession.dataTask(with: url) { [weak self] data, _, error in
                guard self?.isCancelled == false else {
                    print("ApiRequestManager :: downloadImage :: request cancelled for image url = \(url.absoluteString)")
                    return
                }
                print("ApiRequestManager :: downloadImage :: request active for image url = \(url.absoluteString)")
                guard let data = data else {
                    completion(Result.failure(NSError(domain: error.debugDescription, code: 2, userInfo: nil)))
                    return
                }
                completion(.success(data))
            }
            print("ApiRequestManager :: downloadImage :: Starting request for image url = \(url.absoluteString)")
            self?.task?.resume()
        }
    }
    
    func cancelRequest() {
        print("ApiRequestManager :: cancelRequest :: Cancelling request = \(String(describing: task?.currentRequest?.debugDescription))")
        task?.cancel()
        isCancelled = true
    }
}

class NetworkManager {
    static var apiResponseType: ApiResponseType?
    private let apiHandler: IApiHandler?
    
    init?() {
        guard let type = NetworkManager.apiResponseType else {
            return nil
        }
        //TODO: May be we can try to use Factory method design pattern
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
