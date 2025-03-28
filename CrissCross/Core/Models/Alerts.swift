//
//  Alerts.swift
//  CrissCross
//
//  Created by Hridayan Phukan on 28/03/25.
//

import SwiftUI

struct AlertItem: Identifiable {
    let id = UUID()
    var title: Text
    var message: Text
    var buttonTitle: Text
    
}

struct AlertContext {
    static let humanWin = AlertItem(title: Text("Human Wins"), message: Text("You beat your own AI"), buttonTitle: Text("Play Again"))
    static let computerWin = AlertItem(title: Text("Computer Wins"), message: Text("You got beat by your own AI"), buttonTitle: Text("Rematch"))
    static let draw = AlertItem(title: Text("Draw"), message: Text("What a battle of wit."), buttonTitle: Text("Play Again"))
    
}
