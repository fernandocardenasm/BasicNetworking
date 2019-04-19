//
//  APIClientService.swift
//  BasicNetworking
//
//  Created by Fernando Cardenas on 16.04.19.
//

import CryptoSwift
import Foundation

protocol APIClientService {
    // GET
    func send<T: APIRequest>(_ request: T, completion: @escaping (Result<T.Response, MarvelAPIError>) -> Void)
}

class MarvelAPIClientServiceImpl: APIClientService {
    let session: URLSessionProtocol

    init(session: URLSessionProtocol = URLSession(configuration: .default)) {
        self.session = session
    }

    func send<T: APIRequest>(_ request: T, completion: @escaping (Result<T.Response, MarvelAPIError>) -> Void) {
        let endpointURL = makeEndpointURL(for: request)

        guard let url = endpointURL else {
            return
        }
        let task = session.dataTask(with: url) { data, _, error in
            if let _ = error {
                completion(.failure(MarvelAPIError.requestFailed))
            } else if let data = data {
                let decoder = JSONDecoder()
                do {
                    let marvelResponse = try decoder.decode(MarvelResponse<T.Response>.self,
                                                            from: data)
                    guard let dataContainer = marvelResponse.data else {
                        completion(.failure(MarvelAPIError.dataIsNil))
                        return
                    }
                    completion(.success(dataContainer.results))
                } catch {
                    completion(.failure(MarvelAPIError.dataDecodingFailed))
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
        let hash = "\(timestamp)\(GlobalConstants.MarvelAPI.privateKey)\(GlobalConstants.MarvelAPI.publicKey)".md5()
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
            URLQueryItem(name: $0.key,
                         value: String(describing: $0.value))
        }
    }
}

class GetCharactersRequest: APIRequest {
    typealias Response = [ComicCharacter]

    var resourceName: String {
        return GlobalConstants.MarvelAPI.Paths.characters
    }

    var parameters: [String: Any] {
        return [GlobalConstants.MarvelAPI.Parameters.limit: limit]
    }

    let limit: Int

    init(limit: Int = 10) {
        self.limit = limit
    }
}
