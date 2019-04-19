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

class MarvelAPIClientService: XCTestCase {
    func test_encryptionParameters() {
        let dataTask = URLSessionDataTaskMock()
        let session = URLSessionMock(newDataTask: dataTask)
        let service = MarvelAPIClientServiceImpl(session: session)
        let parameters = service.encryptionParameters()
        
        // timestamp
        XCTAssertEqual(parameters.first?.name, GlobalConstants.MarvelAPI.Parameters.timestamp)
        let timestamp = parameters.first?.value
        XCTAssertNotNil(timestamp)
        
        //hash
        XCTAssertEqual(parameters[1].name, GlobalConstants.MarvelAPI.Parameters.hash)
        let hash = "\(timestamp ?? "")\(GlobalConstants.MarvelAPI.privateKey)\(GlobalConstants.MarvelAPI.publicKey)".md5()
        XCTAssertEqual(parameters[1].value, hash)
        
        //apikey
        XCTAssertEqual(parameters.last?.name, GlobalConstants.MarvelAPI.Parameters.apiKey)
        XCTAssertNotNil(parameters.last?.value, GlobalConstants.MarvelAPI.publicKey)
    }
}
