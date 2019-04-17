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
        let task = session.dataTask(with: url) { (data, response, error) in
            if let error = error {
                completion(.failure(error))
            } else if let data = data {
                let decoder = JSONDecoder()
                do {
                    let characters = try decoder.decode(T.Response.self, from: data)
                    completion(.success(characters))
                }
                catch let decondingError {
                    completion(.failure(decondingError))
                }
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

class GetCharactersRequest: APIRequest {
    typealias Response = [Character]

    var resourceName: String {
        return "/characters"
    }

    let limit: Int

    init(limit: Int = 10) {
        self.limit = limit
    }
}

struct Character: Decodable {

}
