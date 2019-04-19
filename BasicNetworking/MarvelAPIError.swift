//
//  MarvelAPIError.swift
//  BasicNetworking
//
//  Created by Fernando on 19.04.19.
//

import Foundation

enum MarvelAPIError: String, Error {
    case requestFailed
    case dataDecodingFailed
    case dataIsNil
    
    var description: String {
        return rawValue
    }
}
