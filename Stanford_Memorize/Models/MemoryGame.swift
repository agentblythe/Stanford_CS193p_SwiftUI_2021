//
//  MemoryGame.swift
//  Stanford_Memorize
//
//  Created by Steve Blythe on 07/07/2021.
//

import Foundation

struct MemoryGame<CardContent> where CardContent: Equatable {
    private(set) var cards: Array<Card>
    
    private var indexOfTheOneAndOnlyFaceUpCard: Int? {
        get { cards.indices.filter( { cards[$0].isFaceUp }).oneAndOnly }
        set { cards.indices.forEach { cards[$0].isFaceUp = ($0 == newValue) } }
    }
    
    private var dateTheOneAndOnlyFaceUpCardWasShown: Date?
    
    private let correctScoreMultiplier = 1
    private let wrongScoreMultiplier = 1
    private(set) var score: Int
    
    mutating func choose(_ card: Card) {
        // If the chosen card is valid and
        //    the chosen card is not face up already and
        //    the chosen card is not matched already
        //
        if let chosenIndex = cards.firstIndex(where: {
            $0.id == card.id
        }), !cards[chosenIndex].isFaceUp, !cards[chosenIndex].isMatched {
            
            // If there is only one face up card then
            // this is the second card to be flipped
            if let potentialMatchIndex = indexOfTheOneAndOnlyFaceUpCard {
                // If first card content matches the seond card content
                if cards[chosenIndex].content == cards[potentialMatchIndex].content {
                    // This is a match so update both cards to be matched
                    cards[chosenIndex].isMatched = true
                    cards[potentialMatchIndex].isMatched = true
                    
                    // Add the match score
                    let interval = Date().timeIntervalSince(dateTheOneAndOnlyFaceUpCardWasShown!)
                    print(interval)
                    score += correctScoreMultiplier * getScore(for: interval)
                } else {
                    // This is a mismatch
                    // deduct one point for each of the cards that have been
                    // seen before
                    if cards[chosenIndex].seen {
                        score -= wrongScoreMultiplier
                    }
                    if cards[potentialMatchIndex].seen {
                        score -= wrongScoreMultiplier
                    }
                }
                dateTheOneAndOnlyFaceUpCardWasShown = nil
                
                // Update the chosen card to have been seen
                cards[chosenIndex].seen = true
                
            // This is a new round so reset all the cards to face down and
            // then flip the chosen one over
            } else {
                indexOfTheOneAndOnlyFaceUpCard = chosenIndex
                dateTheOneAndOnlyFaceUpCardWasShown = Date()
            }
            cards[chosenIndex].isFaceUp = true
            
            // Update the chosen card to have been seen
            cards[chosenIndex].seen = true
        }
    }
    
    private func getScore(for elapsedTime: TimeInterval) -> Int {
        print("\(max(10 - elapsedTime, 1))")
        return Int(max(10 - elapsedTime, 1))
    }
    
    init(pairsToMatch: Int, createCardContent: (Int) -> CardContent) {
        score = 0
        cards = []
        for i in 0..<pairsToMatch {
            let content = createCardContent(i)
            cards.append(Card(content: content, id: i*2))
            cards.append(Card(content: content, id: i*2 + 1))
        }
        cards.shuffle()
    }
    
    struct Card: Identifiable {
        var isFaceUp = true
        var isMatched = false
        let content: CardContent
        var seen = false
        let id: Int
    }
}
