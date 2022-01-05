//
//  ThemeView.swift
//  Stanford_Memorize
//
//  Created by Steve Blythe on 03/07/2021.
//

import SwiftUI

struct ThemeView: View {
    let theme: Theme
    let selected: Bool
    
    var themeTitle: some View {
        HStack {
            Text(theme.name)
                .bold()
            if selected {
                Image(systemName: "checkmark.seal.fill")
            }
        }
        .font(.title)
    }
    
    var body: some View {
        VStack(alignment: .leading) {
            HStack {
                if theme.colours.count == 1 {
                    themeTitle
                        .foregroundColor(Color(validColour: theme.colours[0]))
                } else {
                    themeTitle.gradientForeground(colors: EmojiMemoryGame.translateThemeColoursToGradient(validColours: theme.colours))
                }
            }
            
            Text(theme.emojis)
                .multilineTextAlignment(.leading)
            
            HStack {
                Spacer()
                Text(theme.emojis.count == theme.pairs ? "Find all pairs" : "Find \(theme.pairs) pairs")
                    .font(.body)
            }
        }
        .padding()
    }
}

struct ThemeView_Previews: PreviewProvider {
    static var previews: some View {
        ThemeView(theme: DefaultThemes.all.first!, selected: true)
    }
}
