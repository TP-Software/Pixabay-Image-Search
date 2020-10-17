//
//  PhotosResponse.swift
//  PixabaySearch
//
//  Created by Tushar Patil on 17/10/20.
//

import Foundation

struct PhotosResponse: Codable {
    let total: Int
    let totalHits: Int
    let hits: [Photo]
}
