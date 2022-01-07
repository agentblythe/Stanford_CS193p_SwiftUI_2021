//
//  Cardify.swift
//  Stanford_Memorize
//
//  Created by Steve Blythe on 09/08/2021.
//

import SwiftUI

struct Cardify: AnimatableModifier {
    var colours: [Color]
    var rotation: Double // in degrees
    
    init(isFaceUp: Bool, colours: [Color]) {
        rotation = isFaceUp ? 0 : 180
        self.colours = colours
    }
    
    var isFaceUp: Bool {
        rotation < 90
    }

    // Tell the system to animate the data but we will determine how this looks
    var animatableData: Double {
        get { rotation }
        set { rotation = newValue }
    }
    
    private let cardShape = RoundedRectangle(cornerRadius: DrawingConstants.cornerRadius)
    
    func body(content: Content) -> some View {
        ZStack {
            // Always have the content "showing" which means animations happen
            // correctly due to the view being on screen all the time but change
            // the opacity
            content.opacity(rotation < 90 ? 1 : 0)
            
            if rotation < 90 {
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
        .rotation3DEffect(
            Angle.degrees(rotation),
            axis: (x: 0.0, y: 1.0, z: 0.0)
        )
    }
    
    private struct DrawingConstants {
        static let cornerRadius: CGFloat = 10.0
        static let lineWidth: CGFloat = 2.0
    }
    
}
