//
//  ThemeStore.swift
//  Stanford_Memorize
//
//  Created by Steve Blythe on 24/12/2021.
//

import Foundation
import SwiftUI

class ThemeStore: ObservableObject {
    
    let name: String
    
    @Published var themes = [Theme]() {
        didSet {
            storeThemesInUserDefaults()
        }
    }
    
    init(named name: String) {
        self.name = name
        
        restoreThemesFromUserDefaults()
        
        if themes.isEmpty {
            addDefaultThemes()
        }
    }
    
    private var userDefaultsKey: String {
        return "ThemeStore:" + name
    }
    
    private func storeThemesInUserDefaults() {
        UserDefaults.standard.set(try? JSONEncoder().encode(themes), forKey: userDefaultsKey)
    }
    
    private func restoreThemesFromUserDefaults() {
        if let data = UserDefaults.standard.data(forKey: userDefaultsKey),
           let decodedThemes = try? JSONDecoder().decode([Theme].self, from: data) {
            themes = decodedThemes
        }
    }
    
    private func addDefaultThemes() {
        themes.removeAll()
        themes.insert(contentsOf: DefaultThemes.all, at: 0)
    }
    
    // MARK: - Intents
    func theme(at index: Int) -> Theme {
        let safeIndex = min(max(0, index), themes.count - 1)
        return themes[safeIndex]
    }
    
    func removeTheme(at index: Int) -> Int {
        if themes.count > 1,
           themes.indices.contains(index) {
            themes.remove(at: index)
        }
        return index % themes.count
    }
    
    func insertTheme(_ theme: Theme, at index: Int = 0) {
        let safeIndex = min(max(0, index), themes.count)
        themes.insert(theme, at: safeIndex)
    }
}
