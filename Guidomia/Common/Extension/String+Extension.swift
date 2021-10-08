//
//  String+Extension.swift
//  Guidomia
//
//  Created by Shilpa on 06/10/21.
//

import Foundation

extension String {
    
    ///converts string into the integer format
    func toInt() -> Int? {
        return Int(self)
    }
    
    ///format the price string in the format of thousands, for eg. 15000 will be formatted as 15K
    func formattedForThousand() -> String {
        if let value = self.toInt(),
           value >= 1000 {
            if let rangeOfLastZeroes = self.range(of: "000", options: .backwards) {
                return self.replacingCharacters(in: rangeOfLastZeroes, with: "k")
            }
        }
        return "0"
    }
    
    /// concatenate the current string with other
    /// - Parameters:
    ///   - separator: separator string for eg. " "
    ///   - list: array of other strings to add
    /// - Returns: The concatenated string
    func concatenateWith(separator: String, list: [String]) -> String {
        guard !list.isEmpty else {
            return self
        }
        let stringToAdd = list.joined(separator: separator)
        return self + separator + stringToAdd
    }
}
