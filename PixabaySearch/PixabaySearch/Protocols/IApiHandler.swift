//
//  IApiHandler.swift
//  PixabaySearch
//
//  Created by Tushar Patil on 18/10/20.
//

import Foundation

protocol IApiHandler {
    func requestData(page: Int, query: String, completion: @escaping (Result<PhotosResponse, Error>?) -> Void)
    func downloadImage(photoUrl: String, completion: @escaping (Result<Data, Error>?) -> Void)
    func cancelRequest()
}
