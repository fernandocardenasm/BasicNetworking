//
//  APIClientService.swift
//  BasicNetworking
//
//  Created by Fernando Cardenas on 16.04.19.
//

import Foundation

protocol APIClientService {
    // GET
    func send<T: APIRequest>(_ request: T, completion: @escaping (Result<T.Response, Error>) -> Void)
}

class MarvelAPIClientServiceImpl: APIClientService {
    let session: URLSessionProtocol

    init(session: URLSessionProtocol = URLSession(configuration: .default)) {
        self.session = session
    }

    func send<T>(_ request: T, completion: @escaping (Result<T.Response, Error>) -> Void) where T: APIRequest {
        let endpointURL = makeEndpointURL(for: request)

        guard let url = endpointURL else {
            return
        }
        let task = session.dataTask(with: url) { data, _, error in
            if let error = error {
                completion(.failure(error))
            } else if let data = data {
                let decoder = JSONDecoder()
                do {
                    print(String(decoding: data, as: UTF8.self))
                    let characters = try decoder.decode(T.Response.self, from: data)
                    completion(.success(characters))
                } catch let decondingError {
                    completion(.failure(decondingError))
                }
            }
        }
        task.resume()
    }

    func makeEndpointURL<T: APIRequest>(for request: T) -> URL? {
        var components = URLComponents()
        components.scheme = GlobalConstants.MarvelAPI.scheme
        components.host = GlobalConstants.MarvelAPI.host
        components.path = path(for: request)
        components.port = GlobalConstants.MarvelAPI.port
        components.queryItems = parameters(for: request)
        return components.url
    }
    
    func path<T: APIRequest>(for request: T) -> String {
        return GlobalConstants.MarvelAPI.basePath + request.resourceName
    }

    func parameters<T: APIRequest>(for request: T) -> [URLQueryItem] {
        return encryptionParameters() + filterParameters(for: request)
    }
    
    func encryptionParameters() -> [URLQueryItem] {
        // Common query items needed for all Marvel requests
        let timestamp = "\(Date().timeIntervalSince1970)"
        let hash = "\(timestamp)\(GlobalConstants.MarvelAPI.privateKey)\(GlobalConstants.MarvelAPI.publicKey)".md5
        return [
            URLQueryItem(name: GlobalConstants.MarvelAPI.Parameters.timestamp,
                         value: timestamp),
            URLQueryItem(name: GlobalConstants.MarvelAPI.Parameters.hash,
                         value: hash),
            URLQueryItem(name: GlobalConstants.MarvelAPI.Parameters.apiKey,
                         value: GlobalConstants.MarvelAPI.publicKey)
        ]
    }
    
    func filterParameters<T: APIRequest>(for request: T) -> [URLQueryItem] {
        return request.parameters.map {
            // converts the value from Any to String
            URLQueryItem(name: $0.key, value: String(describing: $0.value))
        }
    }
}

class GetCharactersRequest: APIRequest {
    typealias Response = [Character]

    var resourceName: String {
        return "/characters"
    }

    var parameters: [String: Any] {
        return ["limit": limit]
    }

    let limit: Int

    init(limit: Int = 10) {
        self.limit = limit
    }
}

struct Character: Decodable {}
