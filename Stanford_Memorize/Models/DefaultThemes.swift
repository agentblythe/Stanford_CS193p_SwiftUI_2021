//
//  DefaultThemes.swift
//  Stanford_Memorize
//
//  Created by Steve Blythe on 10/07/2021.
//

import Foundation

struct DefaultThemes {
    static let all: [Theme] = [
        halloween,
        vehicles,
        clocks,
        colours,
        numbers,
        flags
    ]
    
    private static let halloween = Theme(name: "Halloween", emojis: "💀👻🎃😱🍭🐈‍⬛☠️🕷🕸👺🧟‍♂️⚰️🤖👽", pairs: 14, colours: [.orange, .yellow])
    
    private static let vehicles = Theme(name: "Vehicles", emojis: "🚗🚕🚙🚌🚎🏎🚓🚑🚒🚐🛻🚛🚚🚜🛴🚲🛵🏍🛺🚂✈️🛩🚀🚁🚤🛥🛳⛴🚢🚠", pairs: 10, colours: [.blue])
    
    private static let clocks = Theme(name: "Clocks", emojis: "🕐🕑🕒🕓🕔🕕🕖🕗🕘🕙🕚🕛🕜🕝🕞🕟🕠🕡🕢🕣🕤🕥🕦🕧", pairs: 12, colours: [.black])
    
    private static let colours = Theme(name: "Colours", emojis: "🟥🟧🟨🟩🟦🟪⬛️⬜️🟫", pairs: 9, colours: [.red, .orange])
    
    private static let numbers = Theme(name: "Numbers", emojis: "0️⃣1️⃣2️⃣3️⃣4️⃣5️⃣6️⃣7️⃣8️⃣9️⃣🔟", pairs: 11, colours: [.red])
    
    private static let flags = Theme(name: "Flags", emojis: "🏳️🏴🏴‍☠️🏁🚩🏳️‍🌈🏳️‍⚧️🇺🇳🇦🇫🇦🇽🇦🇱🇩🇿🇦🇸🇦🇩🇦🇴🇦🇮🇦🇶🇦🇬🇦🇷🇦🇲🇦🇼🇦🇺🇦🇹🇦🇿", pairs: 10, colours: [.yellow, .cyan])
}
