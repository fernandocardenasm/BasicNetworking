//
//  MarvelDataContainer.swift
//  BasicNetworking
//
//  Created by Fernando on 19.04.19.
//

import Foundation

/// All successful responses return this, and contains all
/// the metainformation about the returned chunk.
struct MarvelDataContainer<Results: Decodable>: Decodable {
    public let offset: Int
    public let limit: Int
    public let total: Int
    public let count: Int
    public let results: Results
}
