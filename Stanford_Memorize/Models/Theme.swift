//
//  Theme.swift
//  Stanford_Memorize
//
//  Created by Steve Blythe on 03/07/2021.
//

import Foundation

struct Theme: Identifiable, Codable, Hashable, Equatable {
    var name: String
    var emojis: String
    var id = UUID()
    var pairs: Int
    var colours: [ValidColour]
    
    init(name: String, emojis: String, pairs: Int, colours: [ValidColour]) {
        self.name = name
        self.emojis = emojis
        self.pairs = pairs
        self.colours = colours
    }
}

