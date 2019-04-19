//
//  MarvelResponse.swift
//  BasicNetworking
//
//  Created by Fernando on 19.04.19.
//

import Foundation

/// Top level response for every request to the Marvel API
/// Everything in the API seems to be optional, so we cannot rely on having values here
struct MarvelResponse<Response: Decodable>: Decodable {
    /// Whether it was ok or not
    public let status: String?
    /// Message that usually gives more information about some error
    public let message: String?
    /// Requested data
    public let data: MarvelDataContainer<Response>?
}
