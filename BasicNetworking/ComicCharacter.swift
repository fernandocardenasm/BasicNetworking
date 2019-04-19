//
//  ComicCharacter.swift
//  BasicNetworking
//
//  Created by Fernando on 19.04.19.
//

import Foundation

struct ComicCharacter: Decodable {
    let id: Int
    let name: String?
    let description: String?
    let thumbnail: MarvelImage?
}
