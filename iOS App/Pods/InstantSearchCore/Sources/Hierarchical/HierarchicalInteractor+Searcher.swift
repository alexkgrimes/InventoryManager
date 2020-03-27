//
//  HierarchicalInteractor+Searcher.swift
//  InstantSearchCore
//
//  Created by Guy Daher on 03/07/2019.
//  Copyright © 2019 Algolia. All rights reserved.
//

import Foundation
import InstantSearchClient

public extension HierarchicalInteractor {
  
  struct SingleIndexSearcherConnection: Connection {
    
    public let interactor: HierarchicalInteractor
    public let searcher: SingleIndexSearcher
    
    public func connect() {
      
      interactor.hierarchicalAttributes.forEach(searcher.indexQueryState.query.updateQueryFacets)
    
      searcher.onResults.subscribePast(with: interactor) { interactor, searchResults in

        if let hierarchicalFacets = searchResults.hierarchicalFacets {
          interactor.item = interactor.hierarchicalAttributes.map { hierarchicalFacets[$0] }.compactMap { $0 }
        } else if let firstHierarchicalAttribute = interactor.hierarchicalAttributes.first {
          interactor.item = searchResults.facets?[firstHierarchicalAttribute].flatMap { [$0] } ?? []
        } else {
          interactor.item = []
        }
      }

    }
    
    public func disconnect() {
      searcher.onResults.cancelSubscription(for: interactor)
    }
    
  }
  
}

public extension HierarchicalInteractor {
  
  @discardableResult func connectSearcher(searcher: SingleIndexSearcher) -> SingleIndexSearcherConnection {
    let connection = SingleIndexSearcherConnection(interactor: self, searcher: searcher)
    connection.connect()
    return connection
  }
  
}
