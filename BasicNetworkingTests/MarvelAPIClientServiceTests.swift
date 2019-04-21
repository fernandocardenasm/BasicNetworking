//
//  MarvelAPIClientServiceTests.swift
//  BasicNetworkingTests
//
//  Created by Fernando on 19.04.19.
//

@testable import BasicNetworking
import CryptoSwift
import Nimble
import RxTest
import RxSwift
import XCTest

class MarvelAPIClientServiceTests: XCTestCase {
    func test_send_getComicCharactersRequest() {
        let dataTask = URLSessionDataTaskMock()
        let session = URLSessionMock(newDataTask: dataTask)
        session.data = DataMocks.getComicCharactersRequestData()
        let service = MarvelAPIClientServiceImpl(session: session)
        let request = GetComicCharactersRequest()
        let disposeBag = DisposeBag()
        
        let expSuccess = expectation(description: "Success is called")
        service.send(request).subscribe(onSuccess: { (comicCharacters) in
            expSuccess.fulfill()
        }, onError: { (_) in
            XCTFail("This should NOT return error")
        }).disposed(by: disposeBag)
        wait(for: [expSuccess], timeout: 0.1)
        expect(dataTask.resumeWasCalled).to(beTrue())
    }
    
    func test_makeEndpointURL_getComicCharactersRequest() {
        let session = URLSessionMock()
        let service = MarvelAPIClientServiceImpl(session: session)
        let request = GetComicCharactersRequest()
        guard let url = service.makeEndpointURL(for: request) else {
            XCTFail("The URL must exist")
            return
        }
        expect(url.scheme).to(equal(GlobalConstants.MarvelAPI.scheme))
        expect(url.host).to(equal(request.host))
        expect(url.path).to(equal(request.path))
        expect(url.port).to(equal(GlobalConstants.MarvelAPI.port))
        
        // the query contains encryption parameter keys
        service.encryptionParameters().forEach {
            expect(url.query?.contains($0.name)).to(beTrue())
        }
        // the query contains also the filter parameter keys and values
        service.filterParameters(for: request).forEach {
            expect(url.query?.contains($0.name)).to(beTrue())
            expect(url.query?.contains($0.value ?? "")).to(beTrue())
        }
    }
    
    func test_encryptionParameters() {
        let session = URLSessionMock()
        let service = MarvelAPIClientServiceImpl(session: session)
        let parameters = service.encryptionParameters()
        
        // timestamp
        expect(parameters.first?.name).to(equal(GlobalConstants.MarvelAPI.Parameters.timestamp))
        let timestamp = parameters.first?.value
        expect(timestamp).notTo(beNil())
        
        // hash
        expect(parameters[1].name).to(equal(GlobalConstants.MarvelAPI.Parameters.hash))
        let hash = "\(timestamp ?? "")\(GlobalConstants.MarvelAPI.privateKey)\(GlobalConstants.MarvelAPI.publicKey)".md5()
        expect(parameters[1].value).to(equal(hash))
        
        // apikey
        expect(parameters.last?.name).to(equal(GlobalConstants.MarvelAPI.Parameters.apiKey))
        expect(parameters.last?.value).to(equal(GlobalConstants.MarvelAPI.publicKey))
    }
    
    func test_filterParameters() {
        let session = URLSessionMock()
        let service = MarvelAPIClientServiceImpl(session: session)
        // it could be any request
        let request = GetComicCharactersRequest()
        let parameters = service.filterParameters(for: request)
        parameters.forEach {
            expect("\(request.parameters[$0.name] ?? "")").to(equal($0.value))
        }
    }
}
