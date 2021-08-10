//
//  View+Cardify.swift
//  Stanford_Memorize
//
//  Created by Steve Blythe on 10/08/2021.
//

import SwiftUI

extension View {
    public func cardify(isFaceUp: Bool, isMatched: Bool, colours: [Color]) -> some View {
        self.modifier(Cardify(isFaceUp: isFaceUp, isMatched: isMatched, colours: colours))
    }
}
