//
//  ComicCharactersViewModel.swift
//  BasicNetworkingTests
//
//  Created by Fernando on 22.04.19.
//

@testable import BasicNetworking
import Foundation
import Nimble
import RxSwift
import XCTest

class ComicCharactersViewModelTests: XCTestCase {
    func test_fetchComichCharacters_success() {
        let session = URLSessionMock()
        let clientService = MarvelAPIClientServiceImpl(session: session)
        let viewModel = ComicCharactersViewModel(clientService: clientService)
    }
}
