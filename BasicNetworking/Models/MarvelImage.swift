//
//  MarvelImage.swift
//  BasicNetworking
//
//  Created by Fernando on 19.04.19.
//

import Foundation

struct MarvelImage: Decodable {
    let url: URL
    
    /// Server sends the remote URL splits in two: the path and the extension
    enum MarvelImageKeys: String, CodingKey {
        case path
        case fileExtension = "extension"
    }
    
    public init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: MarvelImageKeys.self)
        
        let path = try container.decode(String.self,
                                        forKey: .path)
        let fileExtension = try container.decode(String.self,
                                                 forKey: .fileExtension)
        guard let url = URL(string: "\(path).\(fileExtension)") else {
            throw NetworkError.invalidURL
        }
        self.url = url
    }
}

