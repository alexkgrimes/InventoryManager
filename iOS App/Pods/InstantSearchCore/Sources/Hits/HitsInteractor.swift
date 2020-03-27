//
//  HitsInteractor.swift
//  InstantSearch
//
//  Created by Guy Daher on 15/02/2019.
//

import Foundation
import InstantSearchClient

extension HitsInteractor {
  
  class Tracker {
    
  }
  
}

extension HitsInteractor.Tracker {
  
  func trackClick(on hit: Record) {
    
  }
  
}

public class HitsInteractor<Record: Codable>: AnyHitsInteractor {

  public let settings: Settings

  internal let paginator: Paginator<Record>
  private var isLastQueryEmpty: Bool = true
  private let infiniteScrollingController: InfiniteScrollable
  private let mutationQueue: OperationQueue
  
  public let onRequestChanged: Observer<Void>
  public let onResultsUpdated: Observer<SearchResults>
  public let onError: Observer<Swift.Error>
  
  public var pageLoader: PageLoadable? {
    
    get {
      return infiniteScrollingController.pageLoader
    }
    
    set {
      infiniteScrollingController.pageLoader = newValue
    }
    
  }
  
  convenience public init(infiniteScrolling: InfiniteScrolling = Constants.Defaults.infiniteScrolling,
                          showItemsOnEmptyQuery: Bool = Constants.Defaults.showItemsOnEmptyQuery) {
    let settings = Settings(infiniteScrolling: infiniteScrolling,
                            showItemsOnEmptyQuery: showItemsOnEmptyQuery)
    self.init(settings: settings)
  }

  public convenience init(settings: Settings? = nil) {
    self.init(settings: settings,
              paginationController: Paginator<Record>(),
              infiniteScrollingController: InfiniteScrollingController())
  }
  
  internal init(settings: Settings? = nil,
                paginationController: Paginator<Record>,
                infiniteScrollingController: InfiniteScrollable) {
    self.settings = settings ?? Settings()
    self.paginator = paginationController
    self.infiniteScrollingController = infiniteScrollingController
    self.onRequestChanged = .init()
    self.onResultsUpdated = .init()
    self.onError = .init()
    self.mutationQueue = .init()
    self.mutationQueue.maxConcurrentOperationCount = 1
    self.mutationQueue.qualityOfService = .userInitiated
  }

  public func numberOfHits() -> Int {
    guard let hitsPageMap = paginator.pageMap else { return 0 }
    
    if isLastQueryEmpty && !settings.showItemsOnEmptyQuery {
      return 0
    } else {
      return hitsPageMap.count
    }
  }

  public func hit(atIndex index: Int) -> Record? {
    guard let hitsPageMap = paginator.pageMap else { return nil }
    notifyForInfiniteScrolling(rowNumber: index)
    return hitsPageMap[index]
  }
  
  public func rawHitAtIndex(_ row: Int) -> [String: Any]? {
    guard let hit = hit(atIndex: row) else { return nil }
    return toRaw(hit)
  }
    
  public func genericHitAtIndex<R: Decodable>(_ index: Int) throws -> R? {
    guard let hit = hit(atIndex: index) else { return .none }
    return try cast(hit)
  }
  
  public func getCurrentHits() -> [Record] {
    guard let pageMap = paginator.pageMap else { return [] }
    return pageMap.loadedPages.flatMap { $0.items }
  }

  public func getCurrentGenericHits<R>() throws -> [R] where R: Decodable {
    guard let pageMap = paginator.pageMap else { return [] }
    return try pageMap.loadedPages.flatMap { $0.items }.map(cast)
  }
  
  public func getCurrentRawHits() -> [[String: Any]] {
    guard let pageMap = paginator.pageMap else { return [] }
    return pageMap.loadedPages.flatMap { $0.items }.compactMap(toRaw)
  }

}

extension HitsInteractor {
  
  public enum Error: Swift.Error, LocalizedError {
    case incompatibleRecordType
    
    var localizedDescription: String {
      return "Unexpected record type: \(String(describing: Record.self))"
    }
    
  }
  
}

private extension HitsInteractor {
  
  func notifyForInfiniteScrolling(rowNumber: Int) {
    guard
      case .on(let pageLoadOffset) = settings.infiniteScrolling,
      let hitsPageMap = paginator.pageMap else { return }
    
    infiniteScrollingController.calculatePagesAndLoad(currentRow: rowNumber, offset: pageLoadOffset, pageMap: hitsPageMap)
  }
  
  func toRaw(_ hit: Record) -> [String: Any]? {
    guard let data = try? JSONEncoder().encode(hit) else { return .none }
    guard let jsonValue = try? JSONDecoder().decode(JSON.self, from: data) else { return .none }
    return [String: Any](jsonValue)
  }
  
  func cast<R: Decodable>(_ hit: Record) throws -> R {
    if let castedHit = hit as? R {
      return castedHit
    } else {
      throw Error.incompatibleRecordType
    }
  }
  
}

public extension HitsInteractor where Record == JSON {
  
  func rawHitForRow(_ row: Int) -> [String: Any]? {
    return hit(atIndex: row).flatMap([String: Any].init)
  }
  
}

extension HitsInteractor {
  
  public struct Settings {
    
    public var infiniteScrolling: InfiniteScrolling
    public var showItemsOnEmptyQuery: Bool
    
    public init(infiniteScrolling: InfiniteScrolling = Constants.Defaults.infiniteScrolling,
                showItemsOnEmptyQuery: Bool = Constants.Defaults.showItemsOnEmptyQuery) {
      self.infiniteScrolling = infiniteScrolling
      self.showItemsOnEmptyQuery = showItemsOnEmptyQuery
    }
    
  }
  
}

public enum InfiniteScrolling {
  case on(withOffset: Int)
  case off
}

extension HitsInteractor: ResultUpdatable {
  
  @discardableResult public func update(_ searchResults: SearchResults) -> Operation {
    
    let updateOperation = BlockOperation { [weak self] in
      guard let hitsInteractor = self else { return }
      if case .on = hitsInteractor.settings.infiniteScrolling {
        hitsInteractor.infiniteScrollingController.notifyPending(pageIndex: searchResults.stats.page)
        hitsInteractor.infiniteScrollingController.lastPageIndex = searchResults.stats.pagesCount - 1
      }
      hitsInteractor.isLastQueryEmpty = searchResults.stats.query.isNilOrEmpty

      do {
        let page: HitsPage<Record> = try HitsPage(searchResults: searchResults)
        hitsInteractor.paginator.process(page)
        hitsInteractor.onResultsUpdated.fire(searchResults)
      } catch let error {
        Logger.HitsDecoding.failure(hitsInteractor: hitsInteractor, error: error)
        hitsInteractor.onError.fire(error)
      }
    }
    
    mutationQueue.addOperation(updateOperation)
    
    return updateOperation
    
  }
  
  public func notifyQueryChanged() {
    
    mutationQueue.cancelAllOperations()
    
    let queryChangedCompletion = { [weak self] in
      guard let hitsInteractor = self else { return }
      if case .on = hitsInteractor.settings.infiniteScrolling {
        hitsInteractor.infiniteScrollingController.notifyPendingAll()
      }
      
      hitsInteractor.paginator.invalidate()
      hitsInteractor.onRequestChanged.fire(())
    }
    
    mutationQueue.addOperation(queryChangedCompletion)
        
  }
  
  public func process(_ error: Swift.Error, for query: Query) {
    if let pendingPage = query.page {
      infiniteScrollingController.notifyPending(pageIndex: Int(pendingPage))
    }
  }
  
}
