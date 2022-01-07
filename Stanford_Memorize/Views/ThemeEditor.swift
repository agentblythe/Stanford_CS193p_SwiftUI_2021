//
//  ThemeEditor.swift
//  Stanford_Memorize
//
//  Created by Steve Blythe on 24/12/2021.
//

import SwiftUI

struct ThemeEditor: View {
    @Binding var theme: Theme
    
    let minPairs = 2
    
    var body: some View {
        Form {
            nameSection
            addEmojisSection
            removeEmojisSection
            colourSection
            pairsSection
        }
        .navigationTitle("Edit \(theme.name)")
    }
    
    var vGridLayout = [
        GridItem(.adaptive(minimum: 30))
    ]
    
    func handleColourTap(on colour: ValidColour) {
        if theme.colours.count == 2 || theme.colours.count == 0 {
            theme.colours.removeAll()
        }
        theme.colours.append(colour)
    }
    
    var nameSection: some View {
        Section(header: Text("Theme Name")
                    .foregroundColor(theme.name.isEmpty ? .red : .gray)) {
            TextField("Name", text: $theme.name)
        }
    }
    
    @State private var emojisToAdd = ""
    
    var addEmojisSection: some View {
        Section(header: Text("Add Emojis")) {
            TextField("", text: $emojisToAdd)
                .onChange(of: emojisToAdd) { emojis in
                    addEmojis(emojis)
                }
        }
    }
    
    func addEmojis(_ emojis: String) {
        withAnimation {
            theme.emojis = (emojis + theme.emojis)
                .filter { $0.isEmoji }
            .removingDuplicateCharacters
        }
    }
    
    var removeEmojisSection: some View {
        Section(header: HStack {
            Text("Remove Emojis")
            Spacer()
            Text("(\(theme.emojis.count))")
        }) {
            let emojis = theme.emojis.removingDuplicateCharacters.map { String($0) }
            LazyVGrid(columns: [GridItem(.adaptive(minimum: 40))]) {
                ForEach(emojis, id: \.self) { emoji in
                    Text(emoji)
                        .onTapGesture {
                            withAnimation {
                                theme.emojis.removeAll(where: { String($0) == emoji })
                            }
                        }
                }
            }
            .font(.system(size: 40))
        }
    }
    
    var colourSection: some View {
        Section(header: HStack {
            Text("Theme Colour(s)")
                .foregroundColor(theme.colours.count == 0 ? .red : .gray)
            Spacer()
            HStack {
                Text("Preview:")
                ColourPreview(colours: theme.colours)
                    .frame(width: 50)
            }
        }) {
            LazyVGrid(columns: vGridLayout) {
                ForEach(ValidColour.allCases, id: \.self) { colour in
                    ColourChoice(colour: colour)
                        .frame(width: 30, height: 30)
                        .onTapGesture {
                            handleColourTap(on: colour)
                        }
                }
            }
        }
    }
    
    var pairsSection: some View {
        Section(header: Text("Pairs")) {
            Picker("Pairs", selection: $theme.pairs) {
                ForEach(minPairs..<theme.emojis.count + 1, id: \.self) { i in
                    Text("\(i)")
                }
            }
            .pickerStyle(MenuPickerStyle())
        }
    }
}

struct ThemeEditor_Previews: PreviewProvider {
    static var previews: some View {
        ThemeEditor(theme: .constant(DefaultThemes.all.first!))
    }
}
