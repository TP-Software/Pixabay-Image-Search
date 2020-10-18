//
//  ISearchDao.swift
//  PixabaySearch
//
//  Created by Tushar Patil on 18/10/20.
//

protocol ISearchDao {
    func requestData(page: Int, query: String, completion: @escaping (Result<PhotosResponse, Error>?) -> Void)
    func cancelRequest()
}
