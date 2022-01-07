//
//  CardView.swift
//  Stanford_Memorize
//
//  Created by Steve Blythe on 03/07/2021.
//

import SwiftUI

struct CardView: View {
    var card: EmojiMemoryGame.Card
    private let colours: [ValidColour]
    @State private var animatedBonusRemaining : Double = 0
    
    private func startBonusTimeAnimation() {
        animatedBonusRemaining = card.bonusRemaining
        withAnimation(.linear(duration:card.bonusTimeRemaining)) {
            animatedBonusRemaining = 0
        }
    }
    
    init(_ card: EmojiMemoryGame.Card, colours: [ValidColour]) {
        self.card = card
        self.colours = colours
    }
    
    init(_ card: EmojiMemoryGame.Card, colour: ValidColour) {
        self.card = card
        self.colours = [colour]
    }
    
    private struct DrawingConstants {
        static let fontScale: CGFloat = 0.75
        static let fontSize: CGFloat = 50
        static let piePadding: CGFloat = 5
        static let pieOpacity: Double = 0.5
    }
    
    private var oneColour: Bool {
        return colours.count == 1
    }
    
    var body: some View {
        GeometryReader { geometry in
            self.body(for: geometry.size)
        }
    }
    
    @ViewBuilder
    private func body(for size: CGSize) -> some View {
        if card.isFaceUp || !card.isMatched {
            ZStack {
                Group {
                    if card.isConsumingBonusTime {
                        Pie(startAngle: Angle(degrees: 0 - 90), endAngle: Angle(degrees: (1 - animatedBonusRemaining)*360 - 90))
                            .gradientForeground(colors: translatedColours)
                            .onAppear {
                                self.startBonusTimeAnimation()
                            }
                    } else {
                        Pie(startAngle: Angle(degrees: 0 - 90), endAngle: Angle(degrees: (1 - card.bonusRemaining)*360 - 90))
                            .gradientForeground(colors: translatedColours)
                    }
                }
                .padding(1).opacity(0.6)
                .transition(.identity)
                
                Text(card.content)
                    .font(Font.system(size: fontSize(for: size)))
                    .rotationEffect(Angle.degrees(card.isMatched ? 360 : 0))
                    .animation(card.isMatched ? Animation.linear(duration: 1)
                                .repeatForever(autoreverses: false) : .default)
                
            }
            .cardify(isFaceUp: card.isFaceUp, colours: card.theme.colours.map({ c in
                Color(validColour: c)
            }))
            .transition(AnyTransition.scale)
        }
    }
    
    // MARK: - Drawing Constants
    private func fontSize(for size: CGSize) -> CGFloat {
        min(size.width, size.height) * 0.7
    }
    
    var translatedColours: [Color] {
        if colours.count == 1 {
            let colour = Color(validColour: colours.oneAndOnly!)
            return [colour]
        } else {
            return EmojiMemoryGame.translateThemeColoursToGradient(validColours: colours)
        }
    }
}

struct CardView_Previews: PreviewProvider {
    static var previews: some View {
        let card = EmojiMemoryGame.Card(isFaceUp: true, isMatched: false, theme: DefaultThemes.all.first!, content: "🦊", id: 0)
        CardView(card, colours: [ValidColour.orange, ValidColour.black])
    }
}

