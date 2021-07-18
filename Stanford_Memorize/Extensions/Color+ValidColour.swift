//
//  Color+String.swift
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
        }
    }
}
