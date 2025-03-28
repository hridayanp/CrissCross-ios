//
//  Color.swift
//  CrissCross
//
//  Created by Hridayan Phukan on 28/03/25.
//

import UIKit
import SwiftUI


struct ColorTheme {
    let accent = Color("AccentColor")
    let background = Color("BackgroundColor")
    let green = Color("GreenColor")
    let red = Color("RedColor")
    let secondaryText = Color("SecondaryTextColor")
}


extension Color {
    static let theme = ColorTheme()
}
