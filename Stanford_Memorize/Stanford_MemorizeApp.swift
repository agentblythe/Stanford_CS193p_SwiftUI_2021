//
//  Stanford_MemorizeApp.swift
//  Stanford_Memorize
//
//  Created by Steve Blythe on 03/07/2021.
//

import SwiftUI

@main
struct Stanford_MemorizeApp: App {    
    var body: some Scene {
        WindowGroup {
            ThemeListView()
                .environmentObject(ThemeStore(named: "Default"))
        }
    }
}
