//
//  Vehicle.swift
//  Guidomia
//
//  Created by Shilpa on 05/10/21.
//

import Foundation

//This struct holds the information of the vehicle for eg. its name, model, pricing etc.
struct Vehicle: Decodable {
    var modelName: String?
    var makeName: String?
    var customerPrice: Double?
    var marketPrice: Double?
    var rating: Float?
    var consList: [String]?
    var prosList: [String]?
    
    enum CodingKeys: String, CodingKey {
        case modelName = "model"
        case makeName = "make"
        case customerPrice, marketPrice, rating, prosList, consList
    }
}
