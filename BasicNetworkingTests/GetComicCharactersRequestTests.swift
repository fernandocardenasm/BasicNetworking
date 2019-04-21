//
//  GetComicCharactersRequestTests.swift
//  BasicNetworkingTests
//
//  Created by Fernando on 21.04.19.
//

@testable import BasicNetworking
import Foundation
import Nimble
import XCTest

class GetComicCharactersRequestTests: XCTestCase {
    func test_init() {
        let initLimit = 20
        let request = GetComicCharactersRequest(limit: initLimit)
        expect(request.limit).to(equal(initLimit))
        // limit
        expect(request.parameters.count).to(equal(1))
        guard let limit = request.parameters[GlobalConstants.MarvelAPI.Parameters.limit] as? Int else {
            XCTFail("The Parameter limit must exist")
            return
        }
        expect(request.host).to(equal(GlobalConstants.MarvelAPI.host))
        expect(request.path).to(equal(GlobalConstants.MarvelAPI.basePath + GlobalConstants.MarvelAPI.Paths.characters))
        expect(limit).to(equal(initLimit))
    }
}
