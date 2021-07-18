//
//  CardView.swift
//  Stanford_Memorize
//
//  Created by Steve Blythe on 03/07/2021.
//

import SwiftUI

struct CardView: View {
    private let card: EmojiMemoryGame.Card
    private let colours: [ValidColour]
    
    init(_ card: EmojiMemoryGame.Card, colours: [ValidColour]) {
        self.card = card
        self.colours = colours
    }
    
    init(_ card: EmojiMemoryGame.Card, colour: ValidColour) {
        self.card = card
        self.colours = [colour]
    }
    
    private struct DrawingConstants {
        static let cornerRadius: CGFloat = 10.0
        static let lineWidth: CGFloat = 2.0
        static let fontScale: CGFloat = 0.75
    }
    
    private var oneColour: Bool {
        return colours.count == 1
    }
    
    private let cardShape = RoundedRectangle(cornerRadius: DrawingConstants.cornerRadius)
    
    @ViewBuilder
    func front(of card: EmojiMemoryGame.Card, in size: CGSize) -> some View {
        let frontCardShape = cardShape.strokeBorder(lineWidth: DrawingConstants.lineWidth)
        if oneColour {
            let colour = Color(validColour: colours.oneAndOnly!)
            Circle()
                .fill(colour)
            frontCardShape
                .foregroundColor(colour)
        } else {
            let gradient = EmojiMemoryGame.translateThemeColoursToGradient(validColours: colours)
            Circle()
                .fill(LinearGradient(gradient: .init(colors: gradient),
                                     startPoint: .topLeading,
                                     endPoint: .bottomTrailing))
            frontCardShape
                .gradientForeground(colors: gradient)
        }
        Text(card.content)
            .font(font(in: size))
    }
    
    @ViewBuilder
    func back(of card: EmojiMemoryGame.Card) -> some View {
        let backCardShape = cardShape.fill()
        if oneColour {
            backCardShape
                .foregroundColor(Color(validColour: colours[0]))
        } else {
            backCardShape
                .gradientForeground(colors: EmojiMemoryGame.translateThemeColoursToGradient(validColours: colours))
        }
    }
    
    var body: some View {
        GeometryReader { geometry in
            ZStack {
                if card.isFaceUp {
                    front(of: card, in: geometry.size)
                } else if card.isMatched {
                    cardShape.opacity(0)
                } else {
                    back(of: card)
                }
            }
        }
    }
    private func font(in size: CGSize) -> Font {
        Font.system(size: min(size.width, size.height) * DrawingConstants.fontScale)
    }
}

struct CardView_Previews: PreviewProvider {
    static var previews: some View {
        let card = EmojiMemoryGame.Card(isFaceUp: true, isMatched: false, content: "🦊", seen: false, id: 0)
        CardView(card, colour: ValidColour.orange)
    }
}

