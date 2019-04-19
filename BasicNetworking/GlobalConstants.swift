//
//  GlobalConstants.swift
//  BasicNetworking
//
//  Created by Fernando Cardenas on 16.04.19.
//

import Foundation

struct GlobalConstants {
    struct MarvelAPI {
        static let publicKey = "bc950974b1ba1d3491bfd681ba43ed03"
        static let privateKey = "c4210a8106f063ee0a5075c7428b0de54ea58658"
        static let scheme = "https"
        static let host = "gateway.marvel.com"
        static let port = 443
        static let basePath = "/v1/public"

        struct Paths {
            static let characters = "/characters"
        }

        struct Parameters {
            static let timestamp = "ts"
            static let hash = "hash"
            static let apiKey = "apikey"
            static let limit = "limit"
        }
    }
}
