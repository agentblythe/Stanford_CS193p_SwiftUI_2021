//
//  AddThemeView.swift
//  Stanford_Memorize
//
//  Created by Steve Blythe on 27/12/2021.
//

import SwiftUI

struct AddThemeView: View {
    @EnvironmentObject var store: ThemeStore
    
    @Environment(\.presentationMode) var presentationMode
    
    @State var name = ""
    @State var emojis = ""
    @State var colours = [ValidColour]()
    @State var pairs: Int = 2
    
    let minPairs = 2
    
    var body: some View {
        Form {
            Section(header: Text("Theme Name")
                        .foregroundColor(name.isEmpty ? .red : .gray)) {
                TextField("Name", text: $name)
            }
            
            Section(header: HStack {
                Text("Theme Emojis")
                    .foregroundColor(emojis.isEmpty ? .red : .gray)
                Spacer()
                Text("(\(emojis.count))")
            }) {
                TextField("", text: $emojis)
                    .onChange(of: emojis) { emojiString in
                        var emojisArr = [String]()
                        for emoji in emojiString {
                            if emoji.isEmoji {
                                emojisArr.append(String(emoji))
                            }
                        }
                        emojis = emojisArr.joined().removingDuplicateCharacters
                    }
                    .font(.system(size: 40))
            }
            
            Section(header: HStack {
                Text("Theme Colour(s)")
                    .foregroundColor(colours.count == 0 ? .red : .gray)
                Spacer()
                HStack {
                    Text("Preview:")
                    ColourPreview(colours: colours)
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
            
            if emojis.count > 2 {
                Section(header: Text("Pairs")) {
                    Picker("Pairs", selection: $pairs) {
                        ForEach(minPairs..<emojis.count + 1, id: \.self) { i in
                            Text("\(i)")
                        }
                    }
                    .pickerStyle(MenuPickerStyle())
                }
            }
            
            if emojis.count > 2 && colours.count > 0 {
                Section(header: Text("Save")) {
                    Button {
                        saveNewTheme()
                    } label: {
                        Text("Save")
                    }
                }
            }
        }
    }
    
    func saveNewTheme() {
        var theme: Theme
        theme  = Theme(name: name, emojis: emojis, pairs: pairs, colours: colours)
        store.insertTheme(theme)
        
        presentationMode.wrappedValue.dismiss()
    }
    
    var vGridLayout = [
        GridItem(.adaptive(minimum: 30))
    ]
    
    func handleColourTap(on colour: ValidColour) {
        if colours.count == 2 || colours.count == 0 {
            colours.removeAll()
        }
        colours.append(colour)
    }
}

struct AddThemeView_Previews: PreviewProvider {
    static var previews: some View {
        AddThemeView()
    }
}
