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
    
    @State var selectedTheme : Theme? = nil
    
    var body: some View {
        NavigationView {
            VStack {
                VStack {
                    if selectedTheme != nil {
                        NavigationLink(destination: MemoryGameView(game: EmojiMemoryGame(using: selectedTheme!)), isActive: $navigationViewIsActive){ EmptyView() }
                    }
                }.hidden()
            
                List {
                    ForEach(store.themes) { theme in
                        ThemeView(theme: theme, selected: theme.name == store.selectedThemeName)
                            .onTapGesture {
                                if editMode == .active {
                                    print("active")
                                } else {
                                    print("inactive")
                                    store.selectTheme(theme)
                                    selectedTheme = theme
                                    navigationViewIsActive = true
                                }
                            }
                    }
                    .onDelete { indexSet in
                        store.themes.remove(atOffsets: indexSet)
                    }
                    .onMove { indexSet, newOffset in
                        store.themes.move(fromOffsets: indexSet, toOffset: newOffset)
                    }
                }
                .navigationTitle("Themes")
                .navigationBarTitleDisplayMode(.inline)
                .toolbar {
                    ToolbarItem { EditButton()
                    }
                    ToolbarItem(placement: .navigationBarLeading) {
                        addButton
                    }
                }
                .environment(\.editMode, $editMode)
                .popover(item: $editTheme) { theme in
                    ThemeEditor(theme: $store.themes[theme])
                }
                .popover(isPresented: $showAddForm) {
                    AddThemeView()
                        .environmentObject(store)
                }
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
