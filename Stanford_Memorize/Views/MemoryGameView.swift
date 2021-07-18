//
//  MemoryGameView.swift
//  Stanford_Memorize
//
//  Created by Steve Blythe on 03/07/2021.
//

import SwiftUI

struct MemoryGameView: View {
    
    @ObservedObject var game: EmojiMemoryGame
    
    let cardAspectRatio: CGFloat = 2/3
    let columnSpacing: CGFloat = 5.0
    let rowSpacing: CGFloat = 5.0
    let padding: CGFloat = 2.0
    
    var body: some View {
        GeometryReader { fullView in
            ZStack {
                ScrollView {
                    //                    let width: CGFloat = widthThatFits(in: fullView.size, itemAspectRatio: cardAspectRatio)
                    
                    //                    LazyVGrid(columns: [GridItem(.adaptive(minimum: 65), spacing: columnSpacing)], spacing: rowSpacing) {
                    LazyVGrid(columns: [GridItem(.adaptive(minimum: 65))]) {
                        ForEach(game.cards) { card in
                            CardView(card, colours: game.selectedTheme.Colours)
                                .aspectRatio(cardAspectRatio, contentMode: .fit)
                                .onTapGesture {
                                    game.choose(card)
                                }
                        }
                    }
                    .padding()
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
    
    func widthThatFits(in size: CGSize, itemAspectRatio: CGFloat) -> CGFloat {
        let cardCount = game.cards.count
        
        // Assume 1 column to start with
        var columns = 1
        
        // Assume number of rows = number of cards
        var rows = cardCount
        
        repeat {
            let cardWidth =
                (size.width - (columnSpacing * CGFloat(columns - 1))) / CGFloat(columns)
            let cardHeight = cardWidth / itemAspectRatio
            if (CGFloat(rows) * cardHeight) + (rowSpacing * CGFloat(rows - 1)) < size.height {
                break
            }
            columns += 1
            rows = cardCount / columns
            
        } while columns < cardCount
        
        return (size.width - (columnSpacing * CGFloat(columns - 1))) / CGFloat(columns)
    }
}

struct GameView_Previews: PreviewProvider {
    static var previews: some View {
        MemoryGameView(game: EmojiMemoryGame())
    }
}
