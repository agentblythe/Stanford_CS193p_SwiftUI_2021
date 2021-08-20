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
        static let fontScale: CGFloat = 0.75
        static let fontSize: CGFloat = 50
        static let piePadding: CGFloat = 5
        static let pieOpacity: Double = 0.5
    }
    
    private var oneColour: Bool {
        return colours.count == 1
    }
    
    @State private var animatedBonusRemaining: Double = 0
    
    @ViewBuilder
    private func pie(cols: [Color]) -> some View {
        if oneColour {
            pieShape
                .foregroundColor(cols.oneAndOnly!)
        } else {
            pieShape
                .gradientForeground(colors: cols)
        }
    }
    
    @ViewBuilder
    var pieShape: some View {
        if card.isConsumingBonusTime {
            Pie(startAngle: Angle(degrees: 0 - 90), endAngle: Angle(degrees: (1 - animatedBonusRemaining)*360 - 90))
                .onAppear(perform: {
                    animatedBonusRemaining = card.bonusRemaining
                    withAnimation(.linear(duration: card.bonusTimeRemaining)) {
                        animatedBonusRemaining = 0
                    }
                })
        } else {
            Pie(startAngle: Angle(degrees: 0 - 90), endAngle: Angle(degrees: (1 - card.bonusRemaining)*360 - 90))
        }
    }
    
    func timerShape(colours: [Color]) -> some View {
        pie(cols: colours)
            .padding(DrawingConstants.piePadding)
            .opacity(DrawingConstants.pieOpacity)
    }
    
    func timerShape(colour: Color) -> some View {
        timerShape(colours: [colour])
    }
    
    var translatedColours: [Color] {
        if colours.count == 1 {
            let colour = Color(validColour: colours.oneAndOnly!)
            return [colour]
        } else {
            return EmojiMemoryGame.translateThemeColoursToGradient(validColours: colours)
        }
    }
    
    var body: some View {
        GeometryReader { geometry in
            ZStack {
                pie(cols: translatedColours)
                Text(card.content)
                    .rotationEffect(Angle.degrees(card.isMatched ? 360 : 0))
                    .animation(Animation.easeInOut)
                    // This causes issues when you change orientation and when the card size changes because Font is not animatable - changes to this do not get animated
                    //.font(font(in: geometry.size))
                    // Instead, use a set size and scale it up/down accordingly
                    // Scale knows how to animate
                    .font(Font.system(size: DrawingConstants.fontSize))
                    .scaleEffect(scale(thatFits: geometry.size))
                    
            }
            .cardify(isFaceUp: card.isFaceUp, isMatched: card.isMatched, colours: translatedColours)
        }
    }
    
    private func scale(thatFits size: CGSize) -> CGFloat {
        return (min(size.width, size.height) * DrawingConstants.fontScale) / DrawingConstants.fontSize
    }
    
    private func font(in size: CGSize) -> Font {
        Font.system(size: min(size.width, size.height) * DrawingConstants.fontScale)
    }
}

struct CardView_Previews: PreviewProvider {
    static var previews: some View {
        let card = EmojiMemoryGame.Card(isFaceUp: true, isMatched: false, content: "🦊", seen: false, id: 0)
        CardView(card, colours: [ValidColour.orange, ValidColour.black])
    }
}

