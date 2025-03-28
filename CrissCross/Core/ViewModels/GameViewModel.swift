//
//  GameViewModel.swift
//  CrissCross
//
//  Created by Hridayan Phukan on 28/03/25.
//

import Foundation
import SwiftUI

final class GameViewModel: ObservableObject {
    let columns: [GridItem] = [
        GridItem(.flexible()),
        GridItem(.flexible()),
        GridItem(.flexible()),
    ]
    
    
    @Published var moves: [Moves?] = Array(repeating: nil, count: 9)
    @Published var isHumanTurn: Bool = true
    @Published var isGameDisabled: Bool = false
    @Published var alertItem: AlertItem?
    
    
    
    
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

    
    func processPlayerMove(for index: Int) {
        if isSquareOccupied(in: moves, forIndex: index) { return }
        
        moves[index] = Moves(player: .human, boardIndex: index)
        isHumanTurn.toggle()
        
        //check for win condition
        if checkWInCondition(for: .human, in: moves) {
            alertItem = AlertContext.humanWin
            return
        }
        
        if checkForDraw(in: moves) {
            alertItem = AlertContext.draw
            return
        }
        
        isGameDisabled = true
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 1) { [self] in
            let computerPosition = determineComputerMovePosition(in: moves)
            moves[computerPosition] = Moves(player: .computer, boardIndex: computerPosition)
            isGameDisabled = false
            
            if checkWInCondition(for: .computer, in: moves) {
                alertItem = AlertContext.computerWin
                return
            }
        }
    }
}


