//
//  ViewController.swift
//  BasicNetworking
//
//  Created by Fernando Cardenas on 10.04.19.
//

import UIKit

class ViewController: UIViewController {
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.

        let request = GetCharactersRequest(limit: 10)

        let apiClientService = MarvelAPIClientServiceImpl()
        apiClientService.send(request) { result in
            switch result {
            case .success(let comicCharacters):
                print(comicCharacters.first?.thumbnail?.url)
            case .failure(let error):
                print(error.description)
            }
        }
    }
}
