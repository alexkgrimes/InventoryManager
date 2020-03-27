//
//  SearchViewController.swift
//  InventoryManager
//
//  Created by Alex Grimes on 3/24/20.
//  Copyright © 2020 Alex Grimes. All rights reserved.
//

import UIKit
import FirebaseRemoteConfig
import InstantSearch

class SearchViewController: UIViewController {
    
    private enum Constants {
        static let titleFontName = "Helvetica Neue"
    }
    
    // MARK: - View Lifecycle
    init() {
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    let productTitle: UILabel = {
           let label = UILabel()
           label.font = UIFont(name: Constants.titleFontName, size: 24)
           label.textAlignment = .left
           label.textColor = .gray
           label.adjustsFontSizeToFitWidth = true
           label.text = "boop boop"
           label.translatesAutoresizingMaskIntoConstraints = false
           return label
    }()

    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.addSubview(productTitle)
        view.backgroundColor = .blue
        
        NSLayoutConstraint.activate([
            view.heightAnchor.constraint(equalToConstant: 60.0)
        ])
        
        let apiKey = RemoteConfig.remoteConfig()
            .configValue(forKey: "algolia_api_key")
            .stringValue ?? ""

        let client = Client(appID: "ERY7OGMDGD", apiKey: apiKey)
        let index = client.index(withName: "PRODUCTS")
        
        let customRanking = ["name"]
        let settings = ["searchableAttributes": customRanking]
        index.setSettings(settings, completionHandler: { (content, error) -> Void in
            if error != nil {
                print("Error when applying settings: \(error!)")
            }
        })
        
        // Search for a first name
        index.search(Query(query: "melatonen"), completionHandler: { (content, error) -> Void in
            if error == nil {
                print("Result: \(String(describing: content))")
            }
        })
    }
}
