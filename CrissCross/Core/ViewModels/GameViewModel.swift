//
//  GameViewModel.swift
//  CrissCross
//
//  Created by Hridayan Phukan on 28/03/25.
//

import Foundation


func isSquareOccupied(in moves: [Moves?], forIndex index: Int) -> Bool {
    return moves.contains(where: { $0?.boardIndex == index })
}


func determineComputerMovePosition(in moves: [Moves?]) -> Int {
    
    // if AI can win, then win
    let winPattern: Set<Set<Int>> = [
        [0, 1, 2], [3, 4, 5], [6, 7, 8], [0, 3, 6], [1, 4, 7], [2, 5, 8], [0, 4, 8], [2, 4, 6]
    ]
    
    let computerMoves = moves.compactMap { $0 }.filter {$0.player == .computer }
    let computerPositions = Set(computerMoves.map {$0.boardIndex})
    
    for pattern in winPattern {
        let winPositions = pattern.subtracting(computerPositions)
        
        if winPositions.count == 1 {
            let isAvailable = !isSquareOccupied(in: moves, forIndex: winPositions.first!)
            if isAvailable { return winPositions.first! }
        }
    }
    
    // if AI can't win, then block
    let humanMoves = moves.compactMap { $0 }.filter {$0.player == .human }
    let humanPositions = Set(humanMoves.map {$0.boardIndex})
    
    for pattern in winPattern {
        let winPositions = pattern.subtracting(humanPositions)
        
        if winPositions.count == 1 {
            let isAvailable = !isSquareOccupied(in: moves, forIndex: winPositions.first!)
            if isAvailable { return winPositions.first! }
        }
    }
    
    
    // if AI can't block, then take middle square
    let centerSquare = 4
    if !isSquareOccupied(in: moves, forIndex: centerSquare) {
        return centerSquare
    }
    
    
    // if AI can't take middle square, take random available square
    var movePosition = Int.random(in: 0..<9)
    
    while isSquareOccupied(in: moves, forIndex: movePosition) {
        movePosition = Int.random(in: 0..<9)
    }
    
    return movePosition
}

func checkWInCondition(for player:Player, in moves: [Moves?]) -> Bool {
    
    let winPattern: Set<Set<Int>> = [
        [0, 1, 2], [3, 4, 5], [6, 7, 8], [0, 3, 6], [1, 4, 7], [2, 5, 8], [0, 4, 8], [2, 4, 6]
    ]
    
    let playerMoves = moves.compactMap { $0 }.filter {$0.player == player }
    let playerPosition = Set(playerMoves.map {$0.boardIndex})
    
    for pattern in winPattern where pattern.isSubset(of: playerPosition) {
        return true
    }
    
    
    return false
}

func checkForDraw(in moves: [Moves?]) -> Bool {
    return moves.compactMap { $0 }.count == 9
}
