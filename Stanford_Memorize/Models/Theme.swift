//
//  Theme.swift
//  Stanford_Memorize
//
//  Created by Steve Blythe on 03/07/2021.
//

import Foundation

class Theme: Identifiable, Equatable, ObservableObject {
    internal var id = UUID()
    
    @Published private var title: String
    @Published private var symbols: [String]
    @Published private var colours: [ValidColour]
    @Published private var pairs: Int
    
    static func ==(lhs: Theme, rhs: Theme) -> Bool {
        lhs.id == rhs.id && lhs.Title == rhs.Title
    }
    
    public var Title: String {
        get {
            return title
        }
        set {
            title = newValue
        }
    }
    
    public var Symbols: [String] {
        get {
            return symbols
        }
        set {
            symbols = newValue
        }
    }
    
    public var Colours: [ValidColour] {
        get {
            return colours
        }
        set {
            colours = newValue
        }
    }
    
    public var Pairs: Int {
        get {
            return pairs
        }
        set {
            pairs = newValue
        }
    }
    
    var colorCount: Int {
        return Colours.count
    }
    
    // No argument constructor
    init() {
        self.title = "New Theme"
        self.symbols = []
        self.colours = [ValidColour.allCases.randomElement()!]
        self.pairs = 0
    }
    
    // All Argument constructor specifying gradient of colours
    init(title: String, symbols: [String], colours: [ValidColour], pairs: Int) {
        self.title = title
        self.symbols = symbols
        self.colours = colours
        self.pairs = pairs
    }
    
    // All argument constructor specifying a single colour
    init(title: String, symbols: [String], colour: ValidColour, pairs: Int) {
        self.title = title
        self.symbols = symbols
        self.colours = [colour]
        self.pairs = pairs
    }
    
    // Pairs determined to be the same number as symbols
    // Gradient of colours
    init(title: String, symbols: [String], colours: [ValidColour]) {
        self.title = title
        self.symbols = symbols
        self.colours = colours
        self.pairs = symbols.count
    }
    
    // Pairs determined to be the same number as symbols
    // Single Colour
    init(title: String, symbols: [String], colour: ValidColour) {
        self.title = title
        self.symbols = symbols
        self.colours = [colour]
        self.pairs = symbols.count
    }
    
    init(title: String, symbols: [String]) {
        self.title = title
        self.symbols = symbols
        self.colours = [ValidColour.allCases.randomElement()!]
        self.pairs = symbols.count
    }
    
    init(title: String, symbols: [String], pairs: Int) {
        self.title = title
        self.symbols = symbols
        self.colours = [ValidColour.allCases.randomElement()!]
        self.pairs = pairs
    }
    
    public static let exampleTheme = DefaultThemes.halloweenTheme
}

