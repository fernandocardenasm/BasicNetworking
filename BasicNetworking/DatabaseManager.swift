//
//  DatabaseManager.swift
//  BasicNetworking
//
//  Created by Fernando Cardenas on 10.04.19.
//

import Foundation

class DatabaseManager {
    private let session: URLSessionProtocol

    init(session: URLSessionProtocol = URLSession(configuration: .default)) {
        self.session = session
    }

    func loadPlaces(from url: URL, completionHandler: @escaping ((Result<Data, Error>) -> Void)) {
        let task = session.dataTask(with: url) { data, _, error in
            if let error = error {
                completionHandler(.failure(error))
            }
            else if let data = data {
                completionHandler(.success(data))
            }
        }
        task.resume()
    }
}
