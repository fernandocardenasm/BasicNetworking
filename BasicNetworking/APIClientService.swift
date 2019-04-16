//
//  APIClientService.swift
//  BasicNetworking
//
//  Created by Fernando Cardenas on 16.04.19.
//

import Foundation

protocol APIClientService {
    // GET
    func send<T: APIRequest>(_ request: T, completion: Result<T.Response, Error>)
}

class MarvelAPIClientServiceImpl: APIClientService {
    let session: URLSessionProtocol
    let endpoint = "https://gateway.marvel.com:443/v1/public/characters?apikey=bc950974b1ba1d3491bfd681ba43ed03"

    init(session: URLSessionProtocol = URLSession(configuration: .default)) {
        self.session = session
    }

    func send<T>(_ request: T, completion: Result<T.Response, Error>) where T: APIRequest {

    }

    func makeEndpoint<T: APIRequest>(for request: T) -> URLComponents {
        var components = URLComponents()
        components.scheme = "https"
        components.host = "host"
        components.path = request.resourceName

        return components
    }
}
