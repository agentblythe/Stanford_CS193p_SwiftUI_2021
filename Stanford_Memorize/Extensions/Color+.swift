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
        case .cyan:     if #available(iOS 15.0, *) {
            self = .cyan
        } else {
            self = Color(red: 0, green: 255, blue: 255)
        }
        case .indigo:   if #available(iOS 15.0, *) {
            self = .indigo
        } else {
            self = Color(red: 75, green: 0, blue: 130)
        }
        case .mint:     if #available(iOS 15.0, *) {
            self = .mint
        } else {
            self = Color(red: 62, green: 180, blue: 137)
        }
        case .teal:     if #available(iOS 15.0, *) {
            self = .teal
        } else {
            self = Color(red: 0, green: 128, blue: 128)
        }
        case .white:    self = .white
        }
    }
}
