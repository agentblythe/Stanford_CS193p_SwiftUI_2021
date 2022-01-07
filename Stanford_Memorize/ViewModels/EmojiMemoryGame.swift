//
//  EmojiMemoryGame.swift
//  Stanford_Memorize
//
//  Created by Steve Blythe on 07/07/2021.
//

import Foundation
import SwiftUI

class EmojiMemoryGame: ObservableObject {
    typealias Card = MemoryGame<String>.Card
    
    @Published private var model: MemoryGame<String>
    
    var cards: Array<Card> {
        model.cards
    }
    
    var score: Int {
        model.score
    }
    
    var theme: Theme {
        model.theme
    }
    
    var leftViewMidGameTheme: Theme? = nil
    
    init(using theme: Theme) {
        self.model = Self.createMemoryGame(using: theme)
    }
    
    private static func createMemoryGame(using theme: Theme) -> MemoryGame<String> {
        let gameSymbols = theme.emojis.shuffled()[..<theme.pairs]
        
        return MemoryGame<String>(theme: theme) { i in
            String(gameSymbols[i])
        }
    }
    
    static func translateThemeColoursToGradient(validColours: [ValidColour]) -> [Color] {
        var colours = [Color]()
        for validColour in validColours {
            colours.append(Color(validColour: validColour))
        }
        return colours
    }
    
    // MARK: - Intent(s)
    func choose(_ card: Card) {
        model.choose(card: card)
    }
    
    func shuffle() {
        model.shuffle()
    }
    
    func restart() {
        model = Self.createMemoryGame(using: theme)
    }
    
    func resume() {
        
    }
}
