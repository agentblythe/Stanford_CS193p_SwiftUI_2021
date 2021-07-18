//
//  ThemeListView.swift
//  Stanford_Memorize
//
//  Created by Steve Blythe on 03/07/2021.
//

import SwiftUI

struct ThemeListView: View {
    @ObservedObject var game: EmojiMemoryGame

    @State var showingSettingsView = false
    
    @State var editType: EditType = .change
    
    @State var pushRandomGameView = false
    
    var themeOptionsView: some View {
        HStack {
            Spacer()
            playWithSelectedThemeButton
            Spacer()
            settingsButton
            Spacer()
            playWithRandomThemeButton
            Spacer()
        }
        .font(.largeTitle)
    }
    
    var playWithSelectedThemeButton: some View {
        NavigationLink(
            destination: MemoryGameView(game: game),
            label: {
                VStack {
                    Image(systemName: "play.circle")
                }
            })
    }
    
    var playWithRandomThemeButton: some View {
        VStack {
            NavigationLink(
                destination: MemoryGameView(game: game),
                isActive: $pushRandomGameView,
                label: {
                    EmptyView()
                })
            Button(action: {
                game.updateSelectedTheme(with: DefaultThemes.all.randomElement() ?? DefaultThemes.halloweenTheme)
                pushRandomGameView = true
            }, label: {
                VStack {
                    Image(systemName: "questionmark.circle")
                }
            })
            .disabled(game.themes.count < 1)
        }
    }
    
    var settingsButton: some View {
        Button(action: {
            editType = .change
            showingSettingsView = true
        }, label: {
            VStack {
                Image(systemName: "gearshape")
            }
        })
    }
    
    var themeList: some View {
        List {
            ForEach(game.themes, id: \.Title) { theme in
                ThemeView(theme: theme, selected: game.selectedTheme == theme)
                    .onTapGesture {
                        handleThemeTap(theme: theme)
                    }
            }
            .onDelete(perform: delete)
        }
    }
    
    var body: some View {
        NavigationView {
            GeometryReader { fullView in
                if game.themes.count > 0 {
                    ZStack {
                        ScrollView(.vertical, showsIndicators: true) {
                            themeList
                                .frame(width: fullView.size.width, height: fullView.size.height * 0.9, alignment: .center)
                        }
                        themeOptionsView
                            .position(x: fullView.size.width / 2, y: fullView.size.height * 0.95)
                    }
                    .navigationBarTitle("Themes")
                    .navigationBarItems(
                        leading: Button(action: {
                            editType = .new
                            showingSettingsView = true
                        }, label: {
                            Text("Add")
                        }),
                        trailing: EditButton())
                    .sheet(isPresented: $showingSettingsView, content: {
                        EditThemeView(viewModel: game, editType: $editType)
                    })
                } else {
                    Text("Add a theme first!")
                        .font(.title)
                        .position(CGPoint(x: fullView.size.width / 2, y: fullView.size.height / 4))
                }
            }
        }
    }
    
    func handleThemeTap(theme: Theme) {
        game.updateSelectedTheme(with: theme)
    }
    
    func delete(at offsets: IndexSet) {
        game.themes.remove(atOffsets: offsets)
    }
}

struct ThemeListView_Previews: PreviewProvider {
    static var previews: some View {
        ThemeListView(game: EmojiMemoryGame())
    }
}
