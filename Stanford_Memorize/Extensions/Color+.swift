//
//  Color+.swift
//  Stanford_Memorize
//
//  Created by Steve Blythe on 10/07/2021.
//

import SwiftUI

extension Color {
    init(validColour: ValidColour) {
        switch validColour {
        case .black:    self = .black
        case .gray:     self = .gray
        case .red:      self = .red
        case .green:    self = .green
        case .blue:     self = .blue
        case .orange:   self = .orange
        case .yellow:   self = .yellow
        case .pink:     self = .pink
        case .purple:   self = .purple
        case .brown:    if #available(iOS 15.0, *) {
            self = .brown
        } else {
            self = Color(red: 139, green: 69, blue: 19)
        }
        }
    }
}
