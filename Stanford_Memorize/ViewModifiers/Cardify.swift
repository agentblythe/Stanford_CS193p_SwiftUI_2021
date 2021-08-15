//
//  Cardify.swift
//  Stanford_Memorize
//
//  Created by Steve Blythe on 09/08/2021.
//

import SwiftUI

struct Cardify: ViewModifier {
    var isFaceUp: Bool
    var isMatched: Bool
    var colours: [Color]
    
    private let cardShape = RoundedRectangle(cornerRadius: DrawingConstants.cornerRadius)
    
    func body(content: Content) -> some View {
        // Always have the content "showing" which means animations happen
        // correctly due to the view being on screen all the time but change
        // the opacity
        content.opacity(isFaceUp ? 1 : 0)
        
        if isFaceUp {
            cardShape.strokeBorder(lineWidth: DrawingConstants.lineWidth)
        } else {
            let backCardShape = cardShape.fill()
            if colours.count == 1 {
                backCardShape
                    .foregroundColor(colours.first)
            } else {
                backCardShape
                    .gradientForeground(colors: colours)
            }
        }
    }
    
    private struct DrawingConstants {
        static let cornerRadius: CGFloat = 10.0
        static let lineWidth: CGFloat = 2.0
    }
    
}
