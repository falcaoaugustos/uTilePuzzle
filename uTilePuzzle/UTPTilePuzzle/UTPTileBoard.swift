//
//  UTPTileBoard.swift
//  uTilePuzzle
//
//  Created by Augusto Falcão on 9/20/17.
//  Copyright © 2017 Augusto Falcão. All rights reserved.
//

import Foundation

class UTPTileBoard {
    let tileMinSize: Int = 3
    let tileMaxSize: Int = 6

    var size: Int
    var tiles: [Int]

    init() {
        return nil
    }

    init(withSize size: Int) {
        self.size = size
    }

    func isSizeValid(size: Int) -> Bool {
        return size >= tileMinSize && size <= tileMaxSize
    }

    func tileValuesForSize(size: Int) -> [[Int]] {
        var value = 1
        var tiles: [Int] = []
        for i in 0 ..< size {
            var values: [Int] = []
            for j in 0 ..< size {
                if value != pow(size, 2) {
                    value += 1
                    values.append(value)
                } else {
                    values.append(0)
                }
            }
            tiles.append(values)
        }
        return tiles
    }

}
