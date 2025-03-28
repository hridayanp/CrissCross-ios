//
//  GameView.swift
//  CrissCross
//
//  Created by Hridayan Phukan on 28/03/25.
//

import SwiftUI

struct GameView: View {
    
    let columns: [GridItem] = [
        GridItem(.flexible()),
        GridItem(.flexible()),
        GridItem(.flexible()),
    ]
    
    @State private var moves: [Moves?] = Array(repeating: nil, count: 9)
    @State private var isHumanTurn: Bool = true
    @State private var isGameDisabled: Bool = false
    
    var body: some View {
        GeometryReader { geometry in
            VStack {
                Spacer()
                
                LazyVGrid(columns: columns) {
                    ForEach(0..<9, id: \.self) { index in
                        ZStack {
                            Circle()
                                .foregroundColor(.red).opacity(0.6)
                                .frame(width: geometry.size.width / 3 - 15, height: geometry.size.width / 3 - 15)
                            
                            Image(systemName: "xmark")
                                .resizable()
                                .frame(width: 40, height: 40)
                                .foregroundColor(.white)
                        }
                        .onTapGesture {
                            
                            if isSquareOccupied(in: moves, forIndex: index) { return }
                            
                            moves[index] = Moves(player: isHumanTurn ? .human : .computer, boardIndex: index)
                            isHumanTurn.toggle()
                            
                            isGameDisabled = true
                            
                            
                            //check for win condition
                            
                            DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
                                let computerPosition = determineComputerMovePosition(in: moves)
                                moves[computerPosition] = Moves(player: .computer, boardIndex: computerPosition)
                                isGameDisabled = false
                            }
                            
                            
                        }
                    }
                }
                
                Spacer()
            }
            .padding()
            .disabled(isGameDisabled)
        }
    }
}

#Preview {
    GameView()
}
