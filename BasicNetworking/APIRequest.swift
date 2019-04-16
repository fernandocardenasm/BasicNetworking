//
//  APIRequest.swift
//  BasicNetworking
//
//  Created by Fernando Cardenas on 16.04.19.
//

import Foundation

// All the requests implements this protocol
protocol APIRequest: Encodable {
    associatedtype Response: Decodable

    var resourceName: String { get }
}
