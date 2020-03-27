//
//  FacetFilterListConnector.swift
//  InstantSearchCore
//
//  Created by Vladislav Fitc on 26/11/2019.
//  Copyright © 2019 Algolia. All rights reserved.
//

import Foundation

public typealias FacetFilterListConnector = FilterListConnector<Filter.Facet>

public extension FacetFilterListConnector {
  
  convenience init(filters: [InstantSearchCore.Filter.Facet] = [],
                   selectionMode: SelectionMode = .multiple,
                   filterState: FilterState,
                   `operator`: RefinementOperator,
                   groupName: String) {
    let interactor = FacetFilterListInteractor(items: filters,
                                               selectionMode: selectionMode)
    self.init(filterState: filterState,
              interactor: interactor,
              operator: `operator`,
              groupName: groupName)
  }
  
}
