//
//  GameModel.swift
//  CrissCross
//
//  Created by Hridayan Phukan on 28/03/25.
//

import Foundation

enum Player {
    case human, computer
}

struct Moves: Identifiable {
    let id = UUID()
    let player: Player
    let boardIndex: Int
    
    var indicator: String {
        return player == .human ? "xmark" : "circle"
    }
    
}
