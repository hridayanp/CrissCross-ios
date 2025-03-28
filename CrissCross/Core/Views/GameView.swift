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
    @State private var alertItem: AlertItem?
    
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
                            
                            Image(systemName: moves[index]?.indicator ?? "")
                                .resizable()
                                .frame(width: 40, height: 40)
                                .foregroundColor(.white)
                        }
                        .onTapGesture {
                            
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
                            
                            DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
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
                }
                
                Spacer()
            }
            .padding()
            .disabled(isGameDisabled)
            .alert(item: $alertItem) { alertItem in
                Alert(
                    title: alertItem.title,
                    message: alertItem.message,
                    dismissButton: .default(
                        alertItem.buttonTitle,
                        action: {
                            moves = Array(repeating: nil, count: 9)
                        }
                    )
                )
            }
            
        }
    }
}

#Preview {
    GameView()
}
