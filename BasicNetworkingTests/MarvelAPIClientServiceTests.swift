//
//  MarvelAPIClientServiceTests.swift
//  BasicNetworkingTests
//
//  Created by Fernando on 19.04.19.
//

@testable import BasicNetworking
import RxTest
import XCTest
import CryptoSwift
import Nimble

class MarvelAPIClientService: XCTestCase {
    func test_encryptionParameters() {
        let dataTask = URLSessionDataTaskMock()
        let session = URLSessionMock(newDataTask: dataTask)
        let service = MarvelAPIClientServiceImpl(session: session)
        let parameters = service.encryptionParameters()
        
        // timestamp
        expect(parameters.first?.name).to(equal(GlobalConstants.MarvelAPI.Parameters.timestamp))
        let timestamp = parameters.first?.value
        expect(timestamp).notTo(beNil())
        
        //hash
        expect(parameters[1].name).to(equal(GlobalConstants.MarvelAPI.Parameters.hash))
        let hash = "\(timestamp ?? "")\(GlobalConstants.MarvelAPI.privateKey)\(GlobalConstants.MarvelAPI.publicKey)".md5()
        expect(parameters[1].value).to(equal(hash))
        
        //apikey
        expect(parameters.last?.name).to(equal(GlobalConstants.MarvelAPI.Parameters.apiKey))
        expect(parameters.last?.value).to(equal(GlobalConstants.MarvelAPI.publicKey))
    }
    
    func test_filterParameters() {
        let dataTask = URLSessionDataTaskMock()
        let session = URLSessionMock(newDataTask: dataTask)
        let service = MarvelAPIClientServiceImpl(session: session)
        let filterParameters = makeFilterParameters()
        let request = RequestMock(resourceName: "/resourceName",
                                  parameters: filterParameters)
        let parameters = service.filterParameters(for: request)
        expect(parameters.count).to(equal(filterParameters.count))
        parameters.forEach {
            expect(filterParameters.keys.contains($0.name)).to(beTrue())
            expect("\(filterParameters[$0.name] ?? "")").to(equal($0.value))
        }
    }
    
    func test_makeEndpointURL_validURL() {
        let dataTask = URLSessionDataTaskMock()
        let session = URLSessionMock(newDataTask: dataTask)
        let service = MarvelAPIClientServiceImpl(session: session)
        let filterParameters = makeFilterParameters()
        let request = RequestMock(resourceName: "/resourceName",
                                  parameters: filterParameters)
        let url = service.makeEndpointURL(for: request)
        expect(url).notTo(beNil())
    }
    
    func makeFilterParameters() -> [String: Any] {
        return ["int": 0,
                "double": 1.0,
                "string":"",
                "boolean": true]
    }
}

class RequestMock: APIRequest {
    typealias Response = String
    
    let resourceName: String
    let parameters: [String: Any]
    
    init(resourceName: String, parameters: [String: Any]) {
        self.resourceName = resourceName
        self.parameters = parameters
    }
    
    func encode(to encoder: Encoder) throws {
    }
}
