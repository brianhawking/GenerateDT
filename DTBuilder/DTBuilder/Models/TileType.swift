//
//  TileType.swift
//  DTBuilder
//
//  Created by Brian Veitch on 4/16/23.
//

import Foundation

enum TileType: String, Codable, CaseIterable {
    case basicImage = "BASIC_IMAGE"
    case basicTileGroup = "BASIC_TILE_GROUP"
    case basicAction = "BASIC_ACTION"
    case basicLabel = "BASIC_LABEL"
    
    static func asArray() -> [String] {
        return TileType.allCases.map { $0.rawValue }
    }
}
