//
//  View+.swift
//  Stanford_Memorize
//
//  Created by Steve Blythe on 14/07/2021.
//

import SwiftUI

extension View {
    public func gradientForeground(colors: [Color]) -> some View {
        self.overlay(LinearGradient(gradient: .init(colors: colors),
                                    startPoint: .topLeading,
                                    endPoint: .bottomTrailing))
            .mask(self)
    }
}

extension View {
    public func cardify(isFaceUp: Bool, isMatched: Bool, colours: [Color]) -> some View {
        self.modifier(Cardify(isFaceUp: isFaceUp, isMatched: isMatched, colours: colours))
    }
}
