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

    var size: Int = 0
    var tiles: [[Int]] = []

    init?() {
        return nil
    }

    init?(withSize size: Int) {
        if isSizeValid(size: size) == false {
            return nil
        }
        self.size = size
    }

    func isSizeValid(size: Int) -> Bool {
        return size >= tileMinSize && size <= tileMaxSize
    }

    func isCoordinateInBound(coor: CGPoint) -> Bool {
        return coor.x > 0 && Int(coor.x) <= size && coor.y > 0 && Int(coor.y) <= size
    }

    func tileValuesForSize(size: Int) -> [[Int]] {
        var value = 1
        var tiles: [[Int]] = []
        for _ in 0 ..< size {
            var values: [Int] = []
            for _ in 0 ..< size {
                if value != size * size {
                    values.append(value)
                    value += 1
                } else {
                    values.append(0)
                }
            }
            tiles.append(values)
        }

        return tiles
    }

    func setTileAtCoordinate(coor: CGPoint, number: Int) {
        if (isCoordinateInBound(coor: coor)) {
            tiles[Int(coor.y) - 1][Int(coor.x) - 1] = number
        }
    }

    func tileAtCoordinate(coor: CGPoint) -> Int? {
        if tiles.count == 0 {
            tiles = tileValuesForSize(size: size)
        }
        if (isCoordinateInBound(coor: coor)) {
            return tiles[Int(coor.y - 1)][Int(coor.x - 1)]
        }
        return nil
    }

    func canMoveTile(coor: CGPoint) -> Bool {
        var validValues: [Int] = []

        if let downValue = tileAtCoordinate(coor: CGPoint(x: coor.x, y: coor.y - 1)) {
            validValues.append(downValue)
        }
        if let rightValue = tileAtCoordinate(coor: CGPoint(x: coor.x + 1, y: coor.y)) {
            validValues.append(rightValue)
        }
        if let upValue = tileAtCoordinate(coor: CGPoint(x: coor.x, y: coor.y + 1)) {
            validValues.append(upValue)
        }
        if let leftValue = tileAtCoordinate(coor: CGPoint(x: coor.x - 1, y: coor.y)) {
            validValues.append(leftValue)
        }

        var canMove: Bool = false

        for value in validValues {
            canMove = canMove || value == 0
        }

        return canMove
    }

    func shouldMove(_ move: Bool, tileAtCoordinate coor: CGPoint) -> CGPoint {
        if canMoveTile(coor: coor) == false {
            return CGPoint.zero
        }

        let lowerNeighbor = CGPoint(x: coor.x, y: coor.y - 1)
        let rightNeighbor = CGPoint(x: coor.x + 1, y: coor.y)
        let upperNeighbor = CGPoint(x: coor.x, y: coor.y + 1)
        let leftNeighbor = CGPoint(x: coor.x - 1, y: coor.y)

        var neighbor = CGPoint.zero

        if tileAtCoordinate(coor: lowerNeighbor) == 0 {
            neighbor = lowerNeighbor
        } else if tileAtCoordinate(coor: rightNeighbor) == 0 {
            neighbor = rightNeighbor
        } else if tileAtCoordinate(coor: upperNeighbor) == 0 {
            neighbor = upperNeighbor
        } else {
            neighbor = leftNeighbor
        }

        if move {
            guard let number = tileAtCoordinate(coor: coor),
            let neighborNumber = tileAtCoordinate(coor: neighbor)
                else { return CGPoint.zero }

            setTileAtCoordinate(coor: coor, number: neighborNumber)
            setTileAtCoordinate(coor: neighbor, number: number)
        }

        return neighbor
    }

    func shuffle(times: Int) {
        for _ in 0 ..< times {
            var validMoves: [CGPoint] = []
            for j in 1 ... size {
                for i in 1 ... size {
                    let p: CGPoint = CGPoint(x: i, y: j)

                    if canMoveTile(coor: p) {
                        validMoves.append(p)
                    }
                }
            }
            let v: CGPoint = validMoves[Int(arc4random_uniform(UInt32(validMoves.count)))]

            shouldMove(true, tileAtCoordinate: v)
        }
    }

    func isAllTilesCorrect() -> Bool {
        var i = 1
        var correct: Bool = true

        for values in tiles {
            for value in values {
                if value != i {
                    correct = false
                    break
                } else {
                    i = i < size * size - 1 ? i + 1 : 0
                }
            }
        }

        return correct
    }
}
