//
//  URLSessionMock.swift
//  BasicNetworkingTests
//
//  Created by Fernando on 19.04.19.
//

@testable import BasicNetworking
import Foundation

class URLSessionMock: URLSessionProtocol {
    var request: URLRequest?
    var url: URL?
    
    var data: Data?
    var response: URLResponse?
    var error: Error?
    
    let newDataTask: URLSessionDataTaskMock
    
    init(newDataTask: URLSessionDataTaskMock) {
        self.newDataTask = newDataTask
    }
    
    func dataTask(with request: URLRequest, completionHandler: @escaping DataTaskResult) -> URLSessionDataTask {
        self.request = request
        completionHandler(data, response, error)
        return newDataTask
    }
    
    func dataTask(with url: URL, completionHandler: @escaping DataTaskResult) -> URLSessionDataTask {
        self.url = url
        completionHandler(data, response, error)
        return newDataTask
    }
}

class URLSessionDataTaskMock: URLSessionDataTask {
    var resumeWasCalled = false
    
    override func resume() {
        resumeWasCalled = true
        // If super.resume() is called then this exception is returned: "NSInvalidArgumentException", "*** -resume cannot be sent to abstract instance of class
    }
}
