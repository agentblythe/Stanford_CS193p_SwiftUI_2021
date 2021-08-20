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
    
    mutating func shuffle() {
        cards.shuffle()
    }
    
    private func getScore(for elapsedTime: TimeInterval) -> Int {
        //print("\(max(10 - elapsedTime, 1))")
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
        var isFaceUp = false {
            didSet {
                if isFaceUp {
                    startUsingBonusTime()
                } else {
                    stopUsingBonusTime()
                }
            }
        }
        var isMatched = false {
            didSet {
                if isMatched {
                    stopUsingBonusTime()
                }
            }
        }
        let content: CardContent
        var seen = false
        let id: Int
        
        // MARK: - Bonus Time
        
        // This could give matching bonus points
        // if the user matches the card
        // before a certain amount of time passes during which
        // a card is face up
        
        var bonusTimeLimit: TimeInterval = 6
        
        // How long this card has ever been face up
        private var faceUpTime: TimeInterval {
            if let lastFaceUpDate = self.lastFaceUpDate {
                return pastFaceUpTime + Date().timeIntervalSince(lastFaceUpDate)
            } else {
                return pastFaceUpTime
            }
        }
        
        // The last time this card was turned face up and is still face up
        var lastFaceUpDate: Date?
        
        // The accumulated time this card has been face up in the past
        // not including the current time it has been face up (if it is)
        var pastFaceUpTime: TimeInterval = 0
        
        // How much time left before bonus time runs out
        var bonusTimeRemaining: TimeInterval {
            max(0, bonusTimeLimit - faceUpTime)
        }
        
        // Percentage of bonus time remaining
        var bonusRemaining: Double {
            (bonusTimeLimit > 0 && bonusTimeRemaining > 0) ? bonusTimeRemaining/bonusTimeLimit : 0
        }
        
        // Whether the card has matched during the bonus time period
        var hasEarnedBonus: Bool {
            isMatched && bonusRemaining > 0
        }
        
        // Whether we are currently face up, unmatched and have not yet
        // used up bonus window
        var isConsumingBonusTime: Bool {
            isFaceUp && !isMatched && bonusTimeRemaining > 0
        }
        
        // Called when the card transitions to face up state
        private mutating func startUsingBonusTime() {
            if isConsumingBonusTime, lastFaceUpDate == nil {
                lastFaceUpDate = Date()
            }
        }
        
        // Called when the card goes face down or gets matched
        private mutating func stopUsingBonusTime() {
            pastFaceUpTime = faceUpTime
            self.lastFaceUpDate = nil
        }
    }
}
