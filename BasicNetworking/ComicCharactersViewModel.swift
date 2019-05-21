//
//  ComicCharactersViewModel.swift
//  BasicNetworking
//
//  Created by Fernando on 19.04.19.
//

import Foundation
import RxCocoa
import RxSwift

class ComicCharactersViewModel {
    let clientService: APIClientService
    
    // Output
    let comicCharacters: BehaviorSubject<[ComicCharacter]> = BehaviorSubject(value: [])
    
    let disposeBag = DisposeBag()
    
    init(clientService: APIClientService) {
        self.clientService = clientService
    }
    
    func fetchComicCharacters<T: APIRequest>(request: T) {
        clientService
            .send(request)
            .subscribeOn(ConcurrentDispatchQueueScheduler(qos: .background))
            .subscribe(onSuccess: { [weak self] comicCharacters in
                guard let characters = comicCharacters as? [ComicCharacter] else {
                    return
                }
                self?.comicCharacters.onNext(characters)
            }) { [weak self] error in
                self?.comicCharacters.onError(error)
            }.disposed(by: disposeBag)
    }
}

// More Generic View Model

class ResponseViewModel<T: APIRequest> {
    let clientService: APIClientService
    
    // Output
    let response = PublishSubject<T.Response>()
    
    let disposeBag = DisposeBag()
    
    init(clientService: APIClientService) {
        self.clientService = clientService
    }
    
    func fetchResponse(request: T) {
        clientService
            .send(request)
            .subscribeOn(ConcurrentDispatchQueueScheduler(qos: .background))
            .subscribe(onSuccess: { [weak self] response in
                self?.response.onNext(response)
            }) { [weak self] error in
                self?.response.onError(error)
            }.disposed(by: disposeBag)
    }
}

