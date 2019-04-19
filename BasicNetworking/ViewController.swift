//
//  ViewController.swift
//  BasicNetworking
//
//  Created by Fernando Cardenas on 10.04.19.
//

import RxSwift
import UIKit

class ViewController: UIViewController {
    let disposeBag = DisposeBag()
    
    var comicCharactersViewModel: ComicCharactersViewModel?

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.

        let request = GetComicCharactersRequest(limit: 10)
        let apiClientService = MarvelAPIClientServiceImpl()
        comicCharactersViewModel = ComicCharactersViewModel(clientService: apiClientService)
        
        setupBindings()
        
        comicCharactersViewModel?.fetchComicCharacters(request: request)
    }
    
    func setupBindings() {
        comicCharactersViewModel?
            .comicCharacters
            .asDriver(onErrorJustReturn: [])
            .drive(onNext: { comicCharacters in
                print(comicCharacters)
            }).disposed(by: disposeBag)
    }
}
