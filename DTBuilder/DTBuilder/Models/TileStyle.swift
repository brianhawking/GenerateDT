//
//  File.swift
//  DTBuilder
//
//  Created by Brian Veitch on 4/16/23.
//

import Foundation

enum TileStyle: String, Codable, CaseIterable {
    case `default` = "DEFAULT"
    case centered = "CENTERED"
    case progressive = "PROGRESSIVE"
    
    static func asArray() -> [String] {
        return TileStyle.allCases.map { $0.rawValue }
    }
}
