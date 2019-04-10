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

        let databaseManager = DatabaseManager()

        guard let url = URL(string: "https://apple.de") else {
            return
        }
        databaseManager.loadPlaces(from: url) { result in
            switch result {
            case .success(let data):
                print("Data Count: \(data.count)")
            case .failure(let error):
                print("Error: \(error.localizedDescription)")
            }
        }
    }
}
