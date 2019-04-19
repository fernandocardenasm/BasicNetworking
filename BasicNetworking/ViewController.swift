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

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.

        let request = GetCharactersRequest(limit: 10)

        let apiClientService = MarvelAPIClientServiceImpl()
        apiClientService.send(request).subscribe(onSuccess: { comicCharacters in
            print(comicCharacters.first?.thumbnail?.url)
        }) { error in
            print(error.localizedDescription)
        }.disposed(by: disposeBag)
    }
}
