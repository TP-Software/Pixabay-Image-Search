//
//  JsonApiHandler.swift
//  PixabaySearch
//
//  Created by Tushar Patil on 18/10/20.
//

import Foundation

final class JsonApiHandler: IApiHandler {
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
                    print("JsonApiHandler :: requestData :: request cancelled for data url = \(url.absoluteString)")
                    return
                }
                print("JsonApiHandler :: requestData :: request active for data url = \(url.absoluteString)")
                guard let data = data else {
                    completion(Result.failure(NSError(domain: error.debugDescription, code: 2, userInfo: nil)))
                    return
                }
                guard let photos = try? JSONDecoder().decode(PhotosResponse.self, from: data) else {
                    completion(.none)
                    return
                }
                completion(.success(photos))
            }
            print("JsonApiHandler :: requestData :: Starting request for data url = \(url.absoluteString)")
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
                    print("JsonApiHandler :: downloadImage :: request cancelled for image url = \(url.absoluteString)")
                    return
                }
                print("JsonApiHandler :: downloadImage :: request active for image url = \(url.absoluteString)")
                guard let data = data else {
                    completion(Result.failure(NSError(domain: error.debugDescription, code: 2, userInfo: nil)))
                    return
                }
                completion(.success(data))
            }
            print("JsonApiHandler :: downloadImage :: Starting request for image url = \(url.absoluteString)")
            self?.task?.resume()
        }
    }
    
    func cancelRequest() {
        print("JsonApiHandler :: cancelRequest :: Cancelling request = \(String(describing: task?.currentRequest?.debugDescription))")
        task?.cancel()
        isCancelled = true
    }
}
