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
            ZStack {
                AspectVGrid(items: game.cards, aspectRatio: DrawingConstants.aspectRatio) { card in
                    CardView(card, colours: game.selectedTheme.Colours)
                        .padding(4)
                        .onTapGesture {
                            game.choose(card)
                        }
                }
            }
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
}

struct GameView_Previews: PreviewProvider {
    static var previews: some View {
        MemoryGameView(game: EmojiMemoryGame())
    }
}
