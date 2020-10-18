//
//  ImageStorage.swift
//  PixabaySearch
//
//  Created by Tushar Patil on 18/10/20.
//

import UIKit

protocol ImageStorage {
    func add(imageUrl: String, image: UIImage)
    func get(imageUrl: String) -> UIImage?
}
