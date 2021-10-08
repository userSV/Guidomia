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
    /// - Returns: Result type with success or error
    func decode<T: Decodable>(_ type: T.Type, from file: String, fileExtension: String) -> Result<T, Error> {
        guard let fileUrl = self.url(forResource: file, withExtension: fileExtension),
              let data = try? Data(contentsOf: fileUrl) else {
            let errorMessage = Constants.AppMessages.errorInLocatingFile
            return .failure(Constants.CustomError.errorInDecodingData(error: errorMessage))
        }
        let decoder = JSONDecoder()
        do {
            let decodedData = try decoder.decode(T.self, from: data)
            return .success(decodedData)
        } catch(let error) {
            return .failure(Constants.CustomError.errorInDecodingData(error: error.localizedDescription))
        }
    }
}
