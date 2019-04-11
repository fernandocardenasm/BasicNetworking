//
//  DatabaseManager.swift
//  BasicNetworking
//
//  Created by Fernando Cardenas on 10.04.19.
//

import Foundation

class DatabaseManager {
    private let session: URLSessionProtocol

    init(session: URLSessionProtocol = URLSession.shared) {
        self.session = session
    }

    func loadPlaces(from url: URL, completionHandler: @escaping ((Result<Data, Error>) -> Void)) {
        let task = session.dataTask(with: url) { (data, response, error) in
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

//protocol NetworkSessionService {
//    func loadPlaces(with url: URL, completionHandler: @escaping ((Data?, URLResponse?, Error?) -> Void))
//}

protocol URLSessionProtocol {
    typealias DataTaskResult = (Data?, URLResponse?, Error?) -> Void

    func dataTask(with request: URLRequest, completionHandler: @escaping DataTaskResult) -> URLSessionDataTask

    func dataTask(with url: URL, completionHandler: @escaping DataTaskResult) -> URLSessionDataTask
}
extension URLSession: URLSessionProtocol {
//    func dataTask(with request: URLRequest, completionHandler: @escaping DataTaskResult) -> URLSessionDataTaskProtocol {
//        return (dataTask(with: request,
//                         completionHandler: completionHandler) as URLSessionDataTask) as URLSessionDataTaskProtocol
//    }
//
//    func dataTask(with url: URL, completionHandler: @escaping DataTaskResult) -> URLSessionDataTaskProtocol {
//        return (dataTask(with: url,
//                         completionHandler: completionHandler) as URLSessionDataTask) as URLSessionDataTaskProtocol
//    }
}

//protocol URLSessionDataTaskProtocol {
//    func resume()
//}
//
//extension URLSessionDataTask: URLSessionDataTaskProtocol { }

//extension URLSession: NetworkSessionService {
//    func loadPlaces(from url: URL, completionHandler: @escaping ((Data?, URLResponse?, Error?) -> Void)) {
//        let task = dataTask(with: url) { data, response, error in
//            completionHandler(data, response, error)
//        }
//        task.resume()
//    }
//}
