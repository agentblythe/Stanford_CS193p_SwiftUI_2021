//
//  ThemeListView.swift
//  Stanford_Memorize
//
//  Created by Steve Blythe on 03/07/2021.
//

import SwiftUI

struct ThemeListView: View {
    @EnvironmentObject var store: ThemeStore
    
    @Environment(\.presentationMode) var presentationMode
    
    @State private var editMode: EditMode = .inactive
    
    @State private var editTheme: Theme? = nil
    
    @State private var showAddForm = false
    
    @State var navigationViewIsActive: Bool = false
    
    var body: some View {
        VStack {
            NavigationView {
                List {
                    ForEach(store.themes) { theme in
                        NavigationLink(destination: MemoryGameView(game: EmojiMemoryGame(using: theme))
                                        .navigationBarTitle(theme.name)
                        ) {
                            ThemeView(theme: theme, editMode: $editMode)
                                .environmentObject(store)
                        }
                    }
                    .onDelete { indexSet in
                        store.themes.remove(atOffsets: indexSet)
                    }
                    .onMove { indexSet, newOffset in
                        store.themes.move(fromOffsets: indexSet, toOffset: newOffset)
                    }
                }
                .navigationBarTitle(store.name, displayMode: .inline)
                .toolbar {
                    ToolbarItem { EditButton()
                    }
                    ToolbarItem(placement: .navigationBarLeading) {
                        addButton
                    }
                }
                .popover(isPresented: $showAddForm, content: {
                    AddThemeView()
                        .environmentObject(store)
                })
                .environment(\.editMode, $editMode)
            }
        }
    }
    
    var addButton: some View {
        Button {
            showAddForm = true
        } label: {
            Text("Add")
        }
    }
}

struct ThemeListView_Previews: PreviewProvider {
    static var previews: some View {
        ThemeListView()
            .environmentObject(ThemeStore(named: "Preview"))
    }
}
