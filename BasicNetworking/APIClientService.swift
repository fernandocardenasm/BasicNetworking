//
//  APIClientService.swift
//  BasicNetworking
//
//  Created by Fernando Cardenas on 16.04.19.
//

import Foundation

protocol APIClientService {
    // GET
    func get<T: APIRequest>(_ request: T, completion: Result<T.Response, Error>)

    // POST
    func submit<T: APIRequest, M: Encodable>(_ request: T, object: M, completion: Result<T.Response, Error>)

    // PUT
    func update<T: APIRequest, M: Encodable>(_ request: T, object: M, completion: Result<T.Response, Error>)
}

class APIClientServiceImpl: APIClientService {
    let session: URLSessionProtocol

    init(session: URLSessionProtocol = URLSession(configuration: .default)) {
        self.session = session
    }

    func get<T>(_ request: T, completion: Result<T.Response, Error>) where T: APIRequest {
    }

    func submit<T, M>(_ request: T, object: M, completion: Result<T.Response, Error>) where T: APIRequest, M: Encodable {
    }

    func update<T, M>(_ request: T, object: M, completion: Result<T.Response, Error>) where T: APIRequest, M: Encodable {
    }
}
