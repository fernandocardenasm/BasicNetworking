//
//  APIClientService.swift
//  BasicNetworking
//
//  Created by Fernando Cardenas on 16.04.19.
//

import CryptoSwift
import Foundation
import RxSwift

protocol APIClientService {
    // GET
    func send<T: APIRequest>(_ request: T) -> Single<T.Response>
}

class MarvelAPIClientServiceImpl: APIClientService {
    let session: URLSessionProtocol

    init(session: URLSessionProtocol = URLSession(configuration: .default)) {
        self.session = session
    }

    func send<T: APIRequest>(_ request: T) -> Single<T.Response> {
        return Single<T.Response>.create { [weak self] single in
            let disposables = Disposables.create()
            let endpointURL = self?.makeEndpointURL(for: request)

            guard let url = endpointURL else {
                single(.error(NetworkError.invalidURL))
                return disposables
            }
            let task = self?.session.dataTask(with: url) { data, _, error in
                if let error = error {
                    single(.error(error))
                } else if let data = data {
                    let decoder = JSONDecoder()
                    do {
                        let marvelResponse = try decoder.decode(MarvelResponse<T.Response>.self,
                                                                from: data)
                        guard let dataContainer = marvelResponse.data else {
                            return
                        }
                        single(.success(dataContainer.results))
                    } catch let decodingError {
                        single(.error(decodingError))
                    }
                }
            }
            task?.resume()

            return disposables
        }
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
