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

    init(session: URLSessionProtocol = URLSession(configuration: .default)) {
        self.session = session
    }

    func send<T>(_ request: T, completion: Result<T.Response, Error>) where T: APIRequest {
        let endpointURL = makeEndpointURL(for: request)
        
        guard let url = endpointURL else {
            return
        }
        let task = session.dataTask(with: url) { (data, response, error) in
            if let error = error {
            } else if let data = data {
            }
        }
        task.resume()
    }

    func makeEndpointURL<T: APIRequest>(for request: T) -> URL? {
        var components = URLComponents()
        components.scheme = "https"
        components.host = GlobalConstants.MarvelAPI.baseEndpoint
        components.path = request.resourceName + "?apikey=\(GlobalConstants.MarvelAPI.publicKey)"
        return components.url
    }
}
