//
//  DynamicTileContent.swift
//  DTBuilder
//
//  Created by Brian Veitch on 4/16/23.
//

import Foundation

struct Tile: Codable {
    let type: String
    let style: String
    let id: String
    let labels: String?
    let actions: String?
    let questions: String?
    let image: String?
    var tiles: [Tile]
}

extension Tile {
    
    /// used to create an ordered array of tiles to display in the tableview
    func orderedTiles() -> [Tile] {
        var orderedTiless: [Tile] = [self]
        for childTile in self.tiles {
            orderedTiless += childTile.orderedTiles()
        }
        return orderedTiless
    }
    
    func levelOfChildTile(_ tile: Tile, level: Int = 0) -> Int? {
        if tile.id == self.id {
            return level
        } else {
            for childTile in self.tiles {
                if let level = childTile.levelOfChildTile(tile, level: level + 1) {
                    return level
                }
            }
            return nil
        }
    }
    
    /// remove tile by ID
    mutating func removeTile(tile: Tile) {
        
        if self.id == tile.id {
            self = Tile(type: "root", style: "root", id: "root", labels: "", actions: "", questions: "", image: "", tiles: [])
        }
        
        if let index = tiles.firstIndex(where: { $0.id == tile.id }) {
            tiles.remove(at: index)
        } else {
            for i in 0..<tiles.count {
                tiles[i].removeTile(tile: tile)
            }
        }
//
//        var updatedTile = self
//
//        // If the rootTile's id matches the id to remove, return an empty Tile
//        if self.id == tile.id {
//            self = Tile(type: "root", style: "root", id: "root", labels: "", actions: "", questions: "", image: "", tiles: [])
//        }
//
//        // Traverse the rootTile's children
//        for (index, childTile) in self.tiles.enumerated() {
//            // If a child's id matches the id to remove, remove it and its children
//            if childTile.id == id {
//                updatedTile.tiles.remove(at: index)
//                break
//            } else {
//                // If the child has more children, recursively call the function
//                updatedTile.tiles[index] = updatedTile.removeTile(tile: childTile)
//            }
//        }
//
//        self = updatedTile
    }
}
