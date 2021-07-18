//
//  DefaultThemes.swift
//  Stanford_Memorize
//
//  Created by Steve Blythe on 10/07/2021.
//

import Foundation

struct DefaultThemes {
    static let all: [Theme] = [
        halloweenTheme,
        vehiclesTheme,
        coloursTheme,
        buildingsTheme,
        numbersTheme

    ]
    
    static let halloweenTheme = Theme(
        title: "Halloween",
        symbols: ["💀", "👻", "🎃", "😱", "🍭", "🐈‍⬛", "☠️", "🕷", "🕸", "👺", "🧟‍♂️", "⚰️", "🤖", "👽"],
        colours: [.orange, .yellow])
    
    static let vehiclesTheme = Theme(
        title: "Vehicles",
        symbols: ["🚗", "🚕", "🚙", "🚌", "🚎", "🏎", "🚓", "🚑", "🚒", "🚐", "🛻", "🚛", "🚚", "🚜", "🛴", "🚲", "🛵", "🏍", "🛺", "🚂", "✈️", "🛩", "🚀", "🚁", "🚤", "🛥", "🛳", "⛴", "🚢", "🚠"],
        colour: .blue,
        pairs: 10)
    
    static let clocksTheme = Theme(
        title: "Clocks",
        symbols: ["🕐", "🕑", "🕒", "🕓", "🕔", "🕕", "🕖", "🕗", "🕘", "🕙", "🕚", "🕛", "🕜", "🕝", "🕞", "🕟", "🕠", "🕡", "🕢", "🕣", "🕤", "🕥", "🕦", "🕧"])
    
    static let coloursTheme = Theme(
        title: "Colours",
        symbols: ["🟥", "🟧", "🟨", "🟩", "🟦", "🟪", "⬛️", "⬜️", "🟫"])
    
    static let numbersTheme = Theme(
        title: "Numbers",
        symbols: ["0️⃣", "1️⃣", "2️⃣", "3️⃣", "4️⃣", "5️⃣", "6️⃣", "7️⃣", "8️⃣", "9️⃣", "🔟"])
    
    static let buildingsTheme = Theme(
        title: "Buildings",
        symbols: ["🏠", "🏚", "🏭", "🏢", "🏬", "🏣", "🏤", "🏥", "🏦", "🏪", "🏨", "🏫", "🏩", "💒", "🏛", "⛪️", "🕌", "🕍", "🛕"],
        colour: .purple,
        pairs: 11)
}
