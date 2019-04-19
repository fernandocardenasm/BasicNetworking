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
}
