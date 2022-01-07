//
//  ThemeView.swift
//  Stanford_Memorize
//
//  Created by Steve Blythe on 03/07/2021.
//

import SwiftUI

struct ThemeView: View {
    var theme: Theme
    @Binding var editMode : EditMode
    @State private var showThemeEditor = false

    @EnvironmentObject var store: ThemeStore
    
    var themeTitle: some View {
        Text(theme.name)
            .bold()
            .font(.title)
    }
    
    var body: some View {
        HStack {
            if editMode != .inactive {
                HStack {
                    Image(systemName: "pencil.circle.fill").imageScale(.large)
                        .onTapGesture {
                            showThemeEditor = true
                        }
                        .sheet(isPresented: $showThemeEditor, onDismiss: {
                            editMode = EditMode.inactive
                        }) {
                            ThemeEditor(theme: $store.themes[theme])
                        }
                }
                .padding(.horizontal)
            }
        }
        
        
        
        
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
        ThemeView(theme: DefaultThemes.all.first!, editMode: .constant(.active))
    }
}
