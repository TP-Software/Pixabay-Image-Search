//
//  Photo.swift
//  PixabaySearch
//
//  Created by Tushar Patil on 17/10/20.
//

import Foundation

struct Photo: Codable {
    let id: Int
    let previewURL: String
    let largeImageURL: String
}
