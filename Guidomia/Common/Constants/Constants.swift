//
//  Constants.swift
//  Guidomia
//
//  Created by Shilpa on 06/10/21.
//

import Foundation

struct Constants {
    
    struct AlertTitle {
        
        static let ok = "OK"
        static let cancel = "Cancel"
    }
    
    struct VehicleInfo {
        
        static let priceText = "Price"
        static let anyMake = "Any make"
        static let anyModel = "Any model"
        static let resetFilter = "This will reset the filters of make and model."
    }
    
    struct JsonFile {
        
        static let vehicleList = "VehicleList"
        static let jsonExtension = "json"
    }
    
    struct AppMessages {
        
        static let errorInLocatingFile = "Failed to locate file in bundle."
        static let noRecordsFound = "No data found!"
    }
    
    enum CustomError: Error {
        
        case errorInDecodingData(error: String)
    }
}
