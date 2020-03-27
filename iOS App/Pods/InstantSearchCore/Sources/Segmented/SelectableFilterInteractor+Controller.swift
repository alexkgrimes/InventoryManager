//
//  SelectableSegmentInteractor+Filter+Controller.swift
//  InstantSearchCore
//
//  Created by Vladislav Fitc on 02/08/2019.
//  Copyright © 2019 Algolia. All rights reserved.
//

import Foundation

public struct SelectableFilterInteractorControllerConnection<Filter: FilterType, Controller: SelectableSegmentController>: Connection where Controller.SegmentKey == Int {
  
  public typealias Interactor = SelectableSegmentInteractor<Int, Filter>
  
  public let interactor: Interactor
  public let controller: Controller
  public let presenter: FilterPresenter
  
  public init(interactor: Interactor,
              controller: Controller,
              presenter: @escaping FilterPresenter = DefaultPresenter.Filter.present) {
    self.interactor = interactor
    self.controller = controller
    self.presenter = presenter
  }
  
  public func connect() {
    func setControllerItems(controller: Controller, with items: [Int: Filter]) {
      let itemsToPresent = items
        .map { ($0.key, presenter(.init($0.value))) }
        .reduce(into: [:]) { $0[$1.0] = $1.1 }
      controller.setItems(items: itemsToPresent)
    }
    
    controller.setSelected(interactor.selected)
    controller.onClick = interactor.computeSelected(selecting:)
    interactor.onSelectedChanged.subscribePast(with: controller) { controller, selectedItem in
      controller.setSelected(selectedItem)
    }.onQueue(.main)
    interactor.onItemsChanged.subscribePast(with: controller, callback: setControllerItems).onQueue(.main)
    
  }
  
  public func disconnect() {
    controller.onClick = nil
    interactor.onSelectedChanged.cancelSubscription(for: controller)
    interactor.onItemsChanged.cancelSubscription(for: controller)
  }

}

public extension SelectableSegmentInteractor where Segment: FilterType, SegmentKey == Int {
  
  @discardableResult func connectController<Controller: SelectableSegmentController>(_ controller: Controller,
                                                                                     presenter: @escaping FilterPresenter = DefaultPresenter.Filter.present) -> SelectableFilterInteractorControllerConnection<Segment, Controller> where Controller.SegmentKey == Int {
    let connection = SelectableFilterInteractorControllerConnection(interactor: self, controller: controller, presenter: presenter)
    connection.connect()
    return connection
  }
  
}
