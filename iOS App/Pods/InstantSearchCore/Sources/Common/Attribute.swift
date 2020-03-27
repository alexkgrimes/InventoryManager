//  Attribute.swift
//  AlgoliaSearch
//
//  Created by Guy Daher on 10/12/2018.
//  Copyright © 2018 Algolia. All rights reserved.
//
import Foundation

/// Wrapper for filter attribute name
public struct Attribute: CustomStringConvertible, Hashable, ExpressibleByStringLiteral {
  
  public typealias StringLiteralType = String
  public typealias RawValue = String
  
  public var name: String
  
  public init(_ string: String) {
    self.name = string
  }
  
  public init(stringLiteral name: String) {
    self.name = name
  }
  
  public init(rawValue: String) {
    self.name = rawValue
  }
  
  public var description: String {
    return name
  }
  
}

extension Attribute {
  
  public static let tags = Attribute("_tags")
  
}
