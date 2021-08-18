//
//  MemoryGameView.swift
//  Stanford_Memorize
//
//  Created by Steve Blythe on 03/07/2021.
//

import SwiftUI

struct MemoryGameView: View {
    
    @ObservedObject var game: EmojiMemoryGame
    
    private struct DrawingConstants {
        static let aspectRatio: CGFloat = 2/3
    }
    
    var body: some View {
        GeometryReader { fullView in
            VStack {
                gameBody
                shuffleButton
            }
            .padding()
            .onDisappear(perform: {
                game.resetGameState()
            })
            .navigationBarTitle("\(game.selectedTheme.Title)")
            .navigationBarItems(
                leading:
                    Button(action: {
                        game.resetGameState()
                    }, label: {
                        Image(systemName: "repeat.circle")
                            .font(.headline)
                    }),
                trailing:
                    Text("Score: \(game.score)")
                    .font(.headline))
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
        withAnimation {
            for card in game.cards {
                deal(card)
            }
        }
    }
    
    var gameBody: some View {
        AspectVGrid(items: game.cards, aspectRatio: DrawingConstants.aspectRatio, spacing: 5) { card in
            if isUndealt(card) || (card.isMatched && !card.isFaceUp) {
                Color.clear
            } else {
                CardView(card, colours: game.selectedTheme.Colours)
                    .transition(.asymmetric(insertion: .scale, removal: .scale).animation(.easeInOut))
                    .onTapGesture {
                        withAnimation {
                            game.choose(card)
                        }
                    }
            }
        }
        .onChange(of: game.selectedTheme, perform: { _ in
            dealt.removeAll()
            dealAllCards()
        })
        .onAppear(perform: {
            // Ensure the container is on screen first
            // Then we can animate the containers contents to appear
            // A view can only be animated if its container is already on screen
            dealAllCards()
        })
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

}

struct GameView_Previews: PreviewProvider {
    static var previews: some View {
        MemoryGameView(game: EmojiMemoryGame())
    }
}
