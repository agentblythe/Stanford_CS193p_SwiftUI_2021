//
//  MemoryGameView.swift
//  Stanford_Memorize
//
//  Created by Steve Blythe on 03/07/2021.
//

import SwiftUI

struct MemoryGameView: View {
    
    @ObservedObject var game: EmojiMemoryGame
    
    @Namespace private var dealingNamespace
    
    private struct DrawingConstants {
        static let aspectRatio: CGFloat = 2/3
    }
    
    var body: some View {
        GeometryReader { fullView in
            VStack {
                HStack {
                    Button(action:{
                        withAnimation {
                            dealt.removeAll()
                            game.restart()
                        }
                    }) {
                        HStack {
                            Image(systemName: "plus")
                            Text("New Game")
                        }
                        .padding(10.0)
                        .overlay(
                            RoundedRectangle(cornerRadius: 10.0)
                                .stroke(lineWidth: 2.0)
                        )
                    }
                    Spacer()
                    Text("Score: \(self.game.score)")
                }
                .padding()
                Divider()
                ZStack(alignment: .bottom) {
                    VStack {
                        gameBody
                        HStack {
                            Spacer()
                            shuffleButton
                        }
                        .padding(.horizontal)
                    }
                    deckBody
                }
                .padding()
                .navigationBarTitle("\(game.theme.name)")
            }
        }
    }
    
    @State private var dealt = Set<Int>()
    
    private func deal(_ card: EmojiMemoryGame.Card) {
        dealt.insert(card.id)
    }
    
    private func isUndealt(_ card: EmojiMemoryGame.Card) -> Bool {
        return !dealt.contains(card.id)
    }
    
    private func dealAllCards() {
        for card in game.cards {
            withAnimation(dealAnimation(for: card)) {
                deal(card)
            }
        }
    }
    
    private func dealAnimation(for card: EmojiMemoryGame.Card) -> Animation {
        var delay = 0.0
        if let index = game.cards.firstIndex(where: { $0.id == card.id }) {
            delay = Double(index) * (CardConstants.totalDealDuration / Double(game.cards.count))
        }
        return Animation.easeInOut(duration: CardConstants.dealDuration).delay(delay)
    }
    
    private func zIndex(of card: EmojiMemoryGame.Card) -> Double {
        // Higher Z Indices are nearer the top
        -Double(game.cards.firstIndex(where: {$0.id == card.id}) ?? 0)
    }
    
    var gameBody: some View {
        AspectVGrid(items: game.cards, aspectRatio: DrawingConstants.aspectRatio, spacing: 5) { card in
            if isUndealt(card) || (card.isMatched && !card.isFaceUp) {
                Color.clear
            } else {
                CardView(card, colours: game.theme.colours)
                    .matchedGeometryEffect(id: card.id, in: dealingNamespace)
                    .transition(.asymmetric(insertion: .identity, removal: .scale))
                    .zIndex(zIndex(of: card))
                    .onTapGesture {
                        withAnimation {
                            game.choose(card)
                        }
                    }
            }
        }
    }
    
    var shuffleButton: some View {
        Button(action: {
            withAnimation {
                game.shuffle()
            }
        }, label: {
            Text("Shuffle")
        })
    }

    var deckBody: some View {
        ZStack {
            ForEach(game.cards.filter(isUndealt)) { card in
                CardView(card, colours: game.theme.colours)
                    .matchedGeometryEffect(id: card.id, in: dealingNamespace)
                    .transition(.asymmetric(insertion: .opacity, removal: .identity))
                    .zIndex(zIndex(of: card))
            }
        }
        .frame(width: CardConstants.undealtWidth, height: CardConstants.undealtHeight, alignment: .center)
        .onTapGesture(perform: {
            dealAllCards()
        })
        .onChange(of: game.theme, perform: { _ in
            dealt.removeAll()
            dealAllCards()
        })
    }
    
    private struct CardConstants {
        static let aspectRatio: CGFloat = 2/3
        static let dealDuration: Double = 0.5
        static let totalDealDuration: Double = 2
        static let undealtHeight: CGFloat = 90
        static let undealtWidth: CGFloat = undealtHeight * aspectRatio
    }
}

struct GameView_Previews: PreviewProvider {
    static var previews: some View {
        MemoryGameView(game: EmojiMemoryGame(using: DefaultThemes.all.first!))
    }
}
