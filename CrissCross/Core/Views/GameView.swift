//
//  GameView.swift
//  CrissCross
//
//  Created by Hridayan Phukan on 28/03/25.
//

import SwiftUI

struct GameView: View {
    
    @StateObject private var viewModel = GameViewModel()
    
    var body: some View {
        GeometryReader { geometry in
            VStack {
                Spacer()
                
                LazyVGrid(columns: viewModel.columns) {
                    ForEach(0..<9, id: \.self) { index in
                        ZStack {
                            Circle()
                                .foregroundColor(Color.theme.accent)
                                .frame(width: geometry.size.width / 3 - 15, height: geometry.size.width / 3 - 15)
                            
                            Image(systemName: viewModel.moves[index]?.indicator ?? "")
                                .resizable()
                                .frame(width: 40, height: 40)
                                .foregroundColor(.white)
                        }
                        .onTapGesture {
                            viewModel.processPlayerMove(for: index)
                        }
                    }
                }
                
                Spacer()
            }
            .padding()
            .background(Color.theme.background)
            .disabled(viewModel.isGameDisabled)
            .alert(item: $viewModel.alertItem) { alertItem in
                Alert(
                    title: alertItem.title,
                    message: alertItem.message,
                    dismissButton: .default(
                        alertItem.buttonTitle,
                        action: {
                            viewModel.moves = Array(repeating: nil, count: 9)
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
