//
//  JSON.swift
//  InstantSearchCore-iOS
//
//  Created by Vladislav Fitc on 04/03/2019.
//  Copyright © 2019 Algolia. All rights reserved.
//

import Foundation

/// Strongly-typed recursuve JSON representation

public enum JSON: Equatable {
    case string(String)
    case number(Float)
    case dictionary([String:JSON])
    case array([JSON])
    case bool(Bool)
    case null
}

extension JSON: Codable {
    
    public func encode(to encoder: Encoder) throws {
        
        var container = encoder.singleValueContainer()
        
        switch self {
        case let .array(array):
            try container.encode(array)
        case let .dictionary(object):
            try container.encode(object)
        case let .string(string):
            try container.encode(string)
        case let .number(number):
            try container.encode(number)
        case let .bool(bool):
            try container.encode(bool)
        case .null:
            try container.encodeNil()
        }
    }
    
    public init(from decoder: Decoder) throws {
        
        let container = try decoder.singleValueContainer()
        
        if let object = try? container.decode([String: JSON].self) {
            self = .dictionary(object)
        } else if let array = try? container.decode([JSON].self) {
            self = .array(array)
        } else if let string = try? container.decode(String.self) {
            self = .string(string)
        } else if let bool = try? container.decode(Bool.self) {
            self = .bool(bool)
        } else if let number = try? container.decode(Float.self) {
            self = .number(number)
        } else if container.decodeNil() {
            self = .null
        } else {
            throw DecodingError.dataCorrupted(
                .init(codingPath: decoder.codingPath, debugDescription: "Invalid JSON value.")
            )
        }
    }
}

extension JSON: CustomDebugStringConvertible {
    
    public var debugDescription: String {
        switch self {
        case .string(let str):
            return str.debugDescription
        case .number(let num):
            return num.debugDescription
        case .bool(let bool):
            return bool.description
        case .null:
            return "null"
        default:
            let encoder = JSONEncoder()
            encoder.outputFormatting = [.prettyPrinted]
            return (try? encoder.encode(self)).flatMap { String(data: $0, encoding: .utf8) } ?? ""
        }
    }
}

extension JSON {
    
    public func object() -> Any? {
        switch self {
        case .null:
            return nil
        case .string(let string):
            return string
        case .number(let number):
            return number
        case .bool(let bool):
            return bool
        case .array(let array):
            return array.map { $0.object() }
        case .dictionary(let dictionary):

            var resultDictionary = [String: Any]()
            for (key, value) in dictionary {
                resultDictionary[key] = value.object()
            }
            return resultDictionary
        }
    }
    
}

extension JSON {
  
  init<E: Encodable>(_ encodable: E) throws {
    let data = try JSONEncoder().encode(encodable)
    self = try JSONDecoder().decode(JSON.self, from: data)
  }
  
}

extension Dictionary where Key == String, Value == Any {
    
    public init?(_ json: JSON) {
        guard case let .dictionary(dict) = json else {
            return nil
        }
        var resultDictionary = [String: Any]()
        for (key, value) in dict {
            resultDictionary[key] = value.object()
        }
        self = resultDictionary
    }
    
}

extension Array where Element == Any {
    
    public init?(_ json: JSON) {
        guard case let .array(array) = json else {
            return nil
        }
        self = array.compactMap { $0.object() }
    }
    
}
