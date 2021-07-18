//
//  EditThemeView.swift
//  Stanford_Memorize
//
//  Created by Steve Blythe on 03/07/2021.
//

import SwiftUI

enum EditType {
    case new
    case change
}

struct EditThemeView: View {
    @Environment(\.presentationMode) var presentationMode
    
    @ObservedObject var viewModel: EmojiMemoryGame
    
    @Binding var editType: EditType
    
    @State var title = ""
    @State var symbols: [String] = []
    @State var newSymbol = ""
    @State var pairs = 0
    @State var colours = [ValidColour.black]
    
    let colorColumns = [
        GridItem(.adaptive(minimum: 50))
    ]
    
    let symbolColumns = [
        GridItem(.adaptive(minimum: 50, maximum: 100))
    ]
    
    var viewTitle: some View {
        HStack {
            Button(action: {
                cancelChanges()
            }, label: {
                Text("Cancel")
            })
            Spacer()
            Text("Theme Settings")
            Spacer()
            Button(action: {
                applyChanges()
            }, label: {
                Text("Done")
            })
        }
        .padding()
    }
    
    var themeTitleSection: some View {
        Section(header: Text("Title")) {
            TextField("Title", text: $title)
        }
    }
    
    var themeSymbolSection: some View {
        Section(header: HStack {
            Text("Symbols")
            Spacer()
            Text("Tap symbol to exclude")
        }) {
            LazyVGrid(columns: symbolColumns) {
                ForEach(symbols, id: \.self) { symbol in
                    Text(symbol)
                        .font(.title)
                        .onTapGesture {
                            excludeSymbol(symbol: symbol)
                        }
                }
            }
        }
    }
    
    var addSymbolSection: some View {
        Section(header: Text("Add Symbol")) {
            HStack {
                TextField("Symbol", text: $newSymbol)
                Button(action: {
                    addSymbol(newSymbol)
                }, label: {
                    Text("Add")
                })
                .disabled(newSymbol == "")
            }
        }
    }
    
    var pairSection: some View {
        Section(header: Text("Pairs")) {
            if symbols.count < 2 {
                Text("Add at least 2 symbols")
            } else {
                
                Stepper(value: $pairs, in: 2...symbols.count) {
                    Text("\(pairs) pairs")
                }
            }
        }
    }
    
    var colourSection: some View {
        Section(header: Text("Colours")) {
            LazyVGrid(columns: colorColumns) {
                ForEach(ValidColour.allCases, id: \.self) { colour in
                    ZStack {
                        Color(validColour: colour)
                            .frame(width: 50, height: 50, alignment: .center)
                            .clipShape(Circle())
                            .overlay(Circle().stroke(Color.black))
                        if self.colours.contains(colour) {
                            Image(systemName: "checkmark.seal.fill")
                                .offset(x: 20.0, y: -20.0)
                        }
                    }
                    .onTapGesture {
                        handleColourTap(colour: colour)
                    }
                }
            }
        }
    }
    
    var body: some View {
        VStack {
            viewTitle
            
            Form {
                themeTitleSection
                
                themeSymbolSection
                
                addSymbolSection
                
                pairSection
                
                colourSection
            }
        }
        .onAppear(perform: {
            if editType == .change {
                title = viewModel.selectedTheme.Title
                symbols = viewModel.selectedTheme.Symbols
                newSymbol = ""
                pairs = viewModel.selectedTheme.Pairs
                colours = viewModel.selectedTheme.Colours
            } else {
                title = "Untitled"
                symbols = []
                newSymbol = ""
                pairs = 0
                colours = [ValidColour.allCases.randomElement()!]
            }
        })
    }
    
    func handleColourTap(colour: ValidColour) {
        if colours.contains(colour) {
            removeThemeColour(colour)
        }
        else {
            addThemeColour(colour)
        }
    }
    
    private func addThemeColour(_ colour: ValidColour) {
        if !colours.contains(colour) {
            self.colours.append(colour)
        }
    }
    
    private func removeThemeColour(_ colour: ValidColour) {
        self.colours.removeAll { c in
            c == colour
        }
    }
    
    func dismissView() {
        presentationMode.wrappedValue.dismiss()
    }
    
    func applyChanges() {
        if editType == .change {
            let currentTheme = viewModel.themes.first { t in
                t.id == viewModel.selectedTheme.id
            }
            currentTheme?.Colours = colours
            currentTheme?.Pairs = pairs
            currentTheme?.Symbols = symbols
            currentTheme?.Title = title
        } else {
            let theme = Theme(title: title, symbols: symbols, colours: colours, pairs: pairs)
            viewModel.themes.append(theme)
        }

        dismissView()
    }
    
    func cancelChanges() {
        dismissView()
    }
    
    func excludeSymbol(symbol: String) {
        if symbols.contains(symbol) {
            symbols.removeAll { sym in
                sym == symbol
            }
        }
        if pairs > symbols.count {
            pairs = symbols.count
        }
    }
    
    func addSymbol(_ symbol: String) {
        if !symbols.contains(symbol) {
            symbols.append(symbol)
            newSymbol = ""
        }
    }
}


struct EditThemeView_Previews: PreviewProvider {
    static var previews: some View {
        EditThemeView(viewModel: EmojiMemoryGame(), editType: .constant(.change))
    }
}
