//
//  CustomArray.swift
//  PixabaySearch
//
//  Created by Tushar Patil on 18/10/20.
//

import Foundation

typealias CompareSave = Equatable & Codable

struct CustomArray<T: CompareSave>: Codable {
    let maxSize: Int
    var elements: [T] = []
    
    mutating func insert(element: T) {
        removeIfExist(element: element)
        if elements.count >= maxSize {
            remove()
        }
        elements.insert(element, at: 0)
    }
    
    private mutating func remove() {
        elements.removeLast()
    }
    
    private mutating func removeIfExist(element: T) {
        if let index = elements.firstIndex(where: { $0 == element }) {
            elements.remove(at: index)
        }
    }
    
    var count: Int {
        elements.count
    }
    
    subscript(index: Int) -> T {
        get {
            elements[index]
        }
    }
}
