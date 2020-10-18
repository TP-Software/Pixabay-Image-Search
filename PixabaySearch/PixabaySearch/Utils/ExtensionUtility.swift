//
//  ExtensionUtility.swift
//  PixabaySearch
//
//  Created by Tushar Patil on 18/10/20.
//

import Foundation

extension String {
    var trimmedText: String {
        trimmingCharacters(in: .whitespacesAndNewlines)
    }
    
    func isValid() -> Bool {
        return !self.trimmedText.isEmpty
    }
}

extension UserDefaults {
    func setObject<T>(_ object: T?, forKey: String) where T: Encodable {
        let encoder = JSONEncoder()
        if let obj = object, let data = try? encoder.encode(obj) {
            set(data, forKey: forKey)
        }
    }
    
    func getObject<T>(forKey: String, castTo: T.Type) -> T? where T: Decodable {
        guard let data = data(forKey: forKey) else { return nil }
        let decoder = JSONDecoder()
        return try? decoder.decode(castTo, from: data)
    }
}
