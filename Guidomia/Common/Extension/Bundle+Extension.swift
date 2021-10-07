//
//  Bundle+Extension.swift
//  Guidomia
//
//  Created by Shilpa on 07/10/21.
//

import Foundation

extension Bundle {
    /// fetches the content of file and decodes the data from the file into the custom data type
    /// - Parameters:
    ///   - type: Custom data type into which the data is decoded
    ///   - file: name of the file
    ///   - fileExtension: extension of the file
    /// - Returns: <#description#>
    func decode<T: Decodable>(_ type: T.Type, from file: String, fileExtension: String) -> T? {
        guard let url = self.url(forResource: file, withExtension: fileExtension),
              let data = try? Data(contentsOf: url) else {
            fatalError("Failed to locate \(file) in bundle.")
        }
        let decoder = JSONDecoder()
        do {
            return try decoder.decode(T.self, from: data)
        } catch(let error) {
            print(error.localizedDescription)
        }
        return nil
    }
}
