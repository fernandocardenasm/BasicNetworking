//
//  DatabaseManagerTests.swift
//  BasicNetworkingTests
//
//  Created by Fernando Cardenas on 10.04.19.
//

@testable import BasicNetworking
import XCTest

class DatabaseManagerTests: XCTestCase {
    func test_loadPlaces() {
        let session = NetworkSessionServiceMock()
        let dataBaseManager = DatabaseManager(session: session)

        session.data = nil
        session.response = nil
        session.error = NSError(domain: "", code: 0, userInfo: nil)

        let failureExp = expectation(description: "a failure should be returned")
        dataBaseManager.loadPlaces(from: URL(fileURLWithPath: "url")) { result in
            switch result {
            case .success:
                XCTFail("It should not succeed")
            case .failure:
                failureExp.fulfill()
            }
        }
        wait(for: [failureExp], timeout: 0.1)
    }

    func test_loadPlaces_notNil() {
        let session = NetworkSessionServiceMock()
        let dataBaseManager = DatabaseManager(session: session)
        let url = URL(fileURLWithPath: "url")

        session.data = Data(capacity: 0)
        session.response = URLResponse(url: url, mimeType: nil, expectedContentLength: 0, textEncodingName: nil)
        session.error = nil

        let successExp = expectation(description: "a success should be returned")
        dataBaseManager.loadPlaces(from: URL(fileURLWithPath: "url")) { result in
            switch result {
            case .success:
                successExp.fulfill()
            case .failure:
                XCTFail("It should not fail")
            }
        }
        wait(for: [successExp], timeout: 0.1)
    }
}

class NetworkSessionServiceMock: NetworkSessionService {
    var data: Data?
    var response: URLResponse?
    var error: Error?

    func loadPlaces(from url: URL, completionHandler: @escaping ((Data?, URLResponse?, Error?) -> Void)) {
        completionHandler(data, response, error)
    }
}
