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
    
    let searchBarController: TextFieldController = .init(textField: UITextField())

    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = .blue
        
        let apiKey = RemoteConfig.remoteConfig()
            .configValue(forKey: "algolia_api_key")
            .stringValue ?? ""

        let queryInputInteractor: QueryInputInteractor = .init()
        
        let searcher: SingleIndexSearcher = SingleIndexSearcher(appID: "ERY7OGMDGD", apiKey: apiKey, indexName: "PRODUCTS")
        
        queryInputInteractor.connectSearcher(searcher, searchTriggeringMode: .searchAsYouType)
        queryInputInteractor.connectController(searchBarController)
    }
}

public class TextFieldController: NSObject, QueryInputController {
  
  public var onQueryChanged: ((String?) -> Void)?
  public var onQuerySubmitted: ((String?) -> Void)?
  
  let textField: UITextField

  public init (textField: UITextField) {
    self.textField = textField
    super.init()
    setupTextField()
  }
  
  public func setQuery(_ query: String?) {
    textField.text = query
  }

  @objc func textFieldTextChanged(textField: UITextField) {
    guard let searchText = textField.text else { return }
    onQueryChanged?(searchText)
  }
  
  private func setupTextField() {
    textField.returnKeyType = .search
    textField.addTarget(self, action: #selector(textFieldTextChanged), for: .editingChanged)
    textField.delegate = self
  }
  
}

extension TextFieldController: UITextFieldDelegate {
  
  public func textFieldShouldReturn(_ textField: UITextField) -> Bool {
    onQuerySubmitted?(textField.text)
    return true
  }
  
}

