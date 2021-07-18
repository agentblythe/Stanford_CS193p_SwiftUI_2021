//
//  ThemeView.swift
//  Stanford_Memorize
//
//  Created by Steve Blythe on 03/07/2021.
//

import SwiftUI

struct ThemeView: View {
    @ObservedObject var theme: Theme
    let selected: Bool
    
    var themeTitle: some View {
        Text(theme.Title)
            .font(.title)
    }
    
    var body: some View {
        VStack(alignment: .leading) {
            HStack {
                if theme.colorCount == 1 {
                    themeTitle
                        .foregroundColor(Color(validColour: theme.Colours[0]))
                } else {
                    themeTitle.gradientForeground(colors: EmojiMemoryGame.translateThemeColoursToGradient(validColours: theme.Colours))
                        
                }
            }

            HStack {
                Text(theme.Symbols.count == theme.Pairs ? "All pairs from " : "\(theme.Pairs) pairs from ")
                Text(theme.Symbols.joined(separator: ""))
            }
        }
        .padding()
        .border(Color.black, width: selected ? 2.0 : 0.0)
    }
}

struct ThemeView_Previews: PreviewProvider {
    static var previews: some View {
        ThemeView(theme: Theme.exampleTheme, selected: true)
    }
}
