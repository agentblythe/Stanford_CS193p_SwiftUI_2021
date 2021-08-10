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
        static let piePadding: CGFloat = 5
        static let pieOpacity: Double = 0.5
    }
    
    private var oneColour: Bool {
        return colours.count == 1
    }
    
    private let cardShape = RoundedRectangle(cornerRadius: DrawingConstants.cornerRadius)
    
    @ViewBuilder
    private func pie(cols: [Color]) -> some View {
        if oneColour {
            Pie(startAngle: Angle(degrees: 0 - 90), endAngle: Angle(degrees: 110 - 90))
                .fill(cols.oneAndOnly!)
        } else {
            Pie(startAngle: Angle(degrees: 0 - 90), endAngle: Angle(degrees: 110 - 90))
                .fill(LinearGradient(gradient: .init(colors: cols),
                        startPoint: .topLeading,
                        endPoint: .bottomTrailing))
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
    
//    @ViewBuilder
//    func frontContent() -> some View {
//        let frontCardShape = cardShape.strokeBorder(lineWidth: DrawingConstants.lineWidth)
//        if oneColour {
//            let colour = Color(validColour: colours.oneAndOnly!)
//            timerShape(colour: colour)
//            frontCardShape
//                .foregroundColor(colour)
//        } else {
//            let gradient = EmojiMemoryGame.translateThemeColoursToGradient(validColours: colours)
//            timerShape(colours: gradient)
//            frontCardShape
//                .gradientForeground(colors: gradient)
//        }
//    }
    
//    @ViewBuilder
//    func front(of card: EmojiMemoryGame.Card, in size: CGSize) -> some View {
//        frontContent()
//        Text(card.content)
//            .font(font(in: size))
//    }
    
//    @ViewBuilder
//    func back(of card: EmojiMemoryGame.Card) -> some View {
//        let backCardShape = cardShape.fill()
//        if oneColour {
//            backCardShape
//                .foregroundColor(translatedColours.first)
//        } else {
//            backCardShape
//                .gradientForeground(colors: EmojiMemoryGame.translateThemeColoursToGradient(validColours: colours))
//        }
//    }
    
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
                    .font(font(in: geometry.size))
                
//                if card.isFaceUp {
//                    front(of: card, in: geometry.size)
//                } else if card.isMatched {
//                    cardShape.opacity(0)
//                } else {
//                    back(of: card)
//                }
            }
            .cardify(isFaceUp: card.isFaceUp, isMatched: card.isMatched, colours: translatedColours)
        }
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

