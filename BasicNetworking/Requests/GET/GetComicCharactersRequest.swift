//
//  GetComicCharactersRequest.swift
//  BasicNetworking
//
//  Created by Fernando on 19.04.19.
//

import Foundation

struct GetComicCharactersRequest: APIRequest {
    typealias Response = [ComicCharacter]

    var host: String {
        return GlobalConstants.MarvelAPI.host
    }

    var path: String {
        return GlobalConstants.MarvelAPI.basePath + GlobalConstants.MarvelAPI.Paths.characters
    }

    var parameters: [String: Any] {
        return [GlobalConstants.MarvelAPI.Parameters.limit: limit]
    }

    let limit: Int

    init(limit: Int = 10) {
        self.limit = limit
    }
}
