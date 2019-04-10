//
//  DatabaseManager.swift
//  BasicNetworking
//
//  Created by Fernando Cardenas on 10.04.19.
//

import Foundation

class DatabaseManager {
    private let session: NetworkSessionService

    init(session: NetworkSessionService = URLSession.shared) {
        self.session = session
    }

    func loadPlaces(from url: URL, completionHandler: @escaping ((Result<Data, Error>) -> Void)) {
        session.loadPlaces(from: url) { data, _, error in
            if let error = error {
                completionHandler(.failure(error))
            }
            else if let data = data {
                completionHandler(.success(data))
            }
        }
    }
}

protocol NetworkSessionService {
    func loadPlaces(from url: URL, completionHandler: @escaping ((Data?, URLResponse?, Error?) -> Void))
}

extension URLSession: NetworkSessionService {
    func loadPlaces(from url: URL, completionHandler: @escaping ((Data?, URLResponse?, Error?) -> Void)) {
        let task = dataTask(with: url) { data, response, error in
            completionHandler(data, response, error)
        }
        task.resume()
    }
}
