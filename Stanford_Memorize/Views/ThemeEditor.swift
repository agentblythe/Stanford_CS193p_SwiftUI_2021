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
            Section(header: Text("Theme Name")
                        .foregroundColor(theme.name.isEmpty ? .red : .gray)) {
                TextField("Name", text: $theme.name)
            }
            
            addEmojisSection
            
            removeEmojisSection
            
            Section(header: Text("Pairs")) {
                Picker("Pairs", selection: $theme.pairs) {
                    ForEach(minPairs..<theme.emojis.count + 1, id: \.self) { i in
                        Text("\(i)")
                    }
                }
                .pickerStyle(MenuPickerStyle())
            }
        }
        .navigationTitle("Edit \(theme.name)")
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
}

struct ThemeEditor_Previews: PreviewProvider {
    static var previews: some View {
        ThemeEditor(theme: .constant(DefaultThemes.all.first!))
    }
}
