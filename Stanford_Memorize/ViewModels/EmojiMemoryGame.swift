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
    
    @Published private var model: MemoryGame<String>? // = createMemoryGame()
    
    var cards: Array<Card> {
        return model?.cards ?? []
    }
    
    @Published var themes = [Theme]()
    
    @Published var selectedTheme: Theme
    
    var score: Int {
        return model?.score ?? 0
    }
    
    init() {
        selectedTheme = DefaultThemes.all.randomElement() ?? DefaultThemes.halloweenTheme
        model = Self.createMemoryGame(theme: selectedTheme)
        themes.append(contentsOf: DefaultThemes.all)
    }
    
    private static func createMemoryGame(theme: Theme) -> MemoryGame<String> {
        if theme.Pairs > theme.Symbols.count {
            theme.Pairs = theme.Symbols.count
        }
        
        let gameSymbols = theme.Symbols.shuffled()[..<theme.Pairs]
        
        return MemoryGame<String>(pairsToMatch: theme.Pairs) { i in
            gameSymbols[i]
        }
    }
    
    func updateSelectedTheme(with theme : Theme) {
        selectedTheme = theme
        model = Self.createMemoryGame(theme: theme)
    }
    
    func add(theme: Theme) {

    }
    
    func remove(theme: Theme) {

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
        model?.choose(card)
    }
    
    func resetGameState() {
        selectedTheme = themes.randomElement()!
        model = Self.createMemoryGame(theme: selectedTheme)
    }
    
    func shuffle() {
        model?.shuffle()
    }
}
