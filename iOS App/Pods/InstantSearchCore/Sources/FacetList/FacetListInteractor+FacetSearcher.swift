//
//  FacetListInteractor+FacetSearcher.swift
//  InstantSearchCore
//
//  Created by Vladislav Fitc on 29/08/2019.
//  Copyright © 2019 Algolia. All rights reserved.
//

import Foundation
import InstantSearchClient

public extension FacetListInteractor {
  
  struct FacetSearcherConnection: Connection {
    
    public let interactor: FacetListInteractor
    public let searcher: FacetSearcher
    
    public func connect() {
      
      // When new facet search results then update items
      
      searcher.onResults.subscribePast(with: interactor) { interactor, facetResults in
        interactor.update(facetResults)
      }
      
      // For the case of SFFV, very possible that we forgot to add the
      // attribute as searchable in `attributesForFaceting`.
      
      searcher.onError.subscribe(with: interactor) { _, error in
        if let error = error.1 as? HTTPError, error.statusCode == StatusCode.badRequest.rawValue {
          assertionFailure(error.message ?? "")
        }
      }
      
    }
    
    public func disconnect() {
      searcher.onResults.cancelSubscription(for: interactor)
      searcher.onError.cancelSubscription(for: interactor)
    }
    
  }

}

public extension FacetListInteractor {
  
  @discardableResult func connectFacetSearcher(_ facetSearcher: FacetSearcher) -> FacetSearcherConnection {
    let connection = FacetSearcherConnection(interactor: self, searcher: facetSearcher)
    connection.connect()
    return connection
  }
  
}
