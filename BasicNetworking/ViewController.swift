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

//        let databaseManager = DatabaseManager()
//
//        guard let url = URL(string: "https://apple.de") else {
//            return
//        }
//        databaseManager.loadPlaces(from: url) { result in
//            switch result {
//            case .success(let data):
//                print("Data Count: \(String(decoding: data, as: UTF8.self))")
//            case .failure(let error):
//                print("Error: \(error.localizedDescription)")
//            }
//        }
        
        let request = GetCharactersRequest(limit: 10)
        
        let apiClientService = MarvelAPIClientServiceImpl()
        apiClientService.send(request) { (result) in
            switch result {
            case .success(let charachteres):
                print(charachteres)
            case .failure(let error):
                print(error.localizedDescription)
            }
        }
    }
}
