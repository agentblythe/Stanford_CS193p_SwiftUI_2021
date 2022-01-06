//
//  MemoryGame.swift
//  Stanford_Memorize
//
//  Created by Steve Blythe on 07/07/2021.
//

import Foundation

struct MemoryGame<CardContent> where CardContent: Equatable {
    private(set) var cards: Array<Card>
    private(set) var theme: Theme
    private var seenCards: [Card]
    private(set) var score = 0
    private var lastCardChosenTime: Date?
    
    private var indexOfTheOneAndOnlyFaceUpCard: Int? {
        get { cards.indices.filter( { cards[$0].isFaceUp }).oneAndOnly }
        set { cards.indices.forEach { cards[$0].isFaceUp = ($0 == newValue) } }
    }
    
    //private var dateTheOneAndOnlyFaceUpCardWasShown: Date?
    
    private let correctScoreMultiplier = 1
    private let wrongScoreMultiplier = 1
    
    private mutating func getPenaltyPoints(cards: [Card]) -> Int {
        var penaltyPoints = 0
        for card in cards {
            seenCards.contains{$0.content == card.content} ? penaltyPoints -= 1 : seenCards.append(card)
        }
        return penaltyPoints
    }
    
    mutating func choose(card: Card) {
        if let chosenIndex = cards.firstIndex(matching: card), !cards[chosenIndex].isFaceUp, !cards[chosenIndex].isMatched {
            if let potentialMatchIndex = indexOfTheOneAndOnlyFaceUpCard {
                if  cards[chosenIndex].content == cards[potentialMatchIndex].content {
                    cards[chosenIndex].isMatched = true
                    cards[potentialMatchIndex].isMatched = true
                    if cards[chosenIndex].hasEarnedBonus {
                        score += 6
                    } else {
                        score += 1
                    }
                } else {
                    score += getPenaltyPoints(cards: [cards[chosenIndex],cards[potentialMatchIndex]])
                }
                self.cards[chosenIndex].isFaceUp = true
            } else {
                indexOfTheOneAndOnlyFaceUpCard = chosenIndex
                lastCardChosenTime = Date()
            }
        }
    }
//
//    mutating func choose(_ card: Card) {
//        // If the chosen card is valid and
//        //    the chosen card is not face up already and
//        //    the chosen card is not matched already
//        //
//        if let chosenIndex = cards.firstIndex(where: {
//            $0.id == card.id
//        }), !cards[chosenIndex].isFaceUp, !cards[chosenIndex].isMatched {
//
//            // If there is only one face up card then
//            // this is the second card to be flipped
//            if let potentialMatchIndex = indexOfTheOneAndOnlyFaceUpCard {
//                // If first card content matches the seond card content
//                if cards[chosenIndex].content == cards[potentialMatchIndex].content {
//                    // This is a match so update both cards to be matched
//                    cards[chosenIndex].isMatched = true
//                    cards[potentialMatchIndex].isMatched = true
//
//                    // Add the match score
//                    let interval = Date().timeIntervalSince(dateTheOneAndOnlyFaceUpCardWasShown!)
//                    print(interval)
//                    score += correctScoreMultiplier * getScore(for: interval)
//                } else {
//                    // This is a mismatch
//                    // deduct one point for each of the cards that have been
//                    // seen before
//                    if cards[chosenIndex].seen {
//                        score -= wrongScoreMultiplier
//                    }
//                    if cards[potentialMatchIndex].seen {
//                        score -= wrongScoreMultiplier
//                    }
//                }
//                dateTheOneAndOnlyFaceUpCardWasShown = nil
//
//                // Update the chosen card to have been seen
//                cards[chosenIndex].seen = true
//
//            // This is a new round so reset all the cards to face down and
//            // then flip the chosen one over
//            } else {
//                indexOfTheOneAndOnlyFaceUpCard = chosenIndex
//                dateTheOneAndOnlyFaceUpCardWasShown = Date()
//            }
//            cards[chosenIndex].isFaceUp = true
//
//            // Update the chosen card to have been seen
//            cards[chosenIndex].seen = true
//        }
//    }
    
    mutating func shuffle() {
        cards.shuffle()
    }
    
    private func getScore(for elapsedTime: TimeInterval) -> Int {
        return Int(max(10 - elapsedTime, 1))
    }
    
    init(theme: Theme, createCardContent: (Int) -> CardContent) {
        self.theme = theme
        cards = [Card]()
        seenCards = [Card]()
        
        for pairIndex in 0..<theme.pairs {
            let content = createCardContent(pairIndex)
            cards.append(Card(theme: theme, content: content, id: pairIndex*2))
            cards.append(Card(theme: theme, content: content, id: pairIndex*2+1))
        }
        cards.shuffle()
    }
    
    struct Card: Identifiable {
        var isFaceUp: Bool = false {
            didSet {
                if isFaceUp {
                    startUsingBonusTime()
                } else {
                    stopUsingBonusTime()
                }
            }
        }
        
        var isMatched: Bool = false {
            didSet {
                stopUsingBonusTime()
            }
        }
        
        var theme: Theme
        var content: CardContent
        var id: Int
        
        var bonusTimeLimit: TimeInterval = 6
        
        private var faceUpTime: TimeInterval {
            if let lastFaceUpDate = self.lastFaceUpDate {
                return pastFaceUpTime + Date().timeIntervalSince(lastFaceUpDate)
            } else {
                return pastFaceUpTime
            }
        }
        
        var lastFaceUpDate: Date?
        
        var pastFaceUpTime: TimeInterval = 0
        
        var bonusTimeRemaining: TimeInterval {
            max(0, bonusTimeLimit - faceUpTime)
        }
        
        var bonusRemaining: Double {
            (bonusTimeLimit > 0 && bonusTimeRemaining > 0) ? bonusTimeRemaining/bonusTimeLimit : 0
        }
        
        var hasEarnedBonus: Bool {
            isMatched && bonusTimeRemaining > 0
        }
        
        var isConsumingBonusTime: Bool {
            isFaceUp && !isMatched && bonusTimeRemaining > 0
        }

        private mutating func startUsingBonusTime(){
            if isConsumingBonusTime, lastFaceUpDate == nil {
                lastFaceUpDate = Date()
            }
        }
        
        private mutating func stopUsingBonusTime(){
            pastFaceUpTime = faceUpTime
            self.lastFaceUpDate = nil
        }
    }
}
