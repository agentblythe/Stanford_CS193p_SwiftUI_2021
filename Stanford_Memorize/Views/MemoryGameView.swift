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
    
    var gameBody: some View {
        AspectVGrid(items: game.cards, aspectRatio: DrawingConstants.aspectRatio, spacing: 5) { card in
            if card.isMatched && !card.isFaceUp {
                Color.clear
            } else {
                CardView(card, colours: game.selectedTheme.Colours)
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
}

struct GameView_Previews: PreviewProvider {
    static var previews: some View {
        MemoryGameView(game: EmojiMemoryGame())
    }
}
