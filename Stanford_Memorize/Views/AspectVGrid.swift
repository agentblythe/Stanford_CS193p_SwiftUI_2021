//
//  AspectVGrid.swift
//  Stanford_Memorize
//
//  Created by Steve Blythe on 18/07/2021.
//

import SwiftUI

struct AspectVGrid<Item: Identifiable, ItemView: View>: View {
    var items: [Item]
    var aspectRatio: CGFloat
    var content: (Item) -> ItemView
    
    init(items: [Item], aspectRatio: CGFloat, @ViewBuilder content: @escaping (Item) -> ItemView) {
        self.items = items
        self.aspectRatio = aspectRatio
        self.content = content
    }
    
    var body: some View {
        GeometryReader { geometry in
            VStack {
                LazyVGrid(columns: [adaptiveGridItem(width: widthThatFits(in: geometry.size))], spacing: 0.0) {
                    ForEach(items) { item in
                        content(item)
                            .aspectRatio(aspectRatio, contentMode: .fit)
                    }
                }
                Spacer(minLength: 0)
            }
        }
    }
    
    private func adaptiveGridItem(width: CGFloat) -> GridItem {
        var gridItem = GridItem(.adaptive(minimum: width))
        gridItem.spacing = 0.0
        return gridItem
    }
    
    private func widthThatFits(in size: CGSize) -> CGFloat {
        let itemCount = items.count
        
        // Assume 1 column to start with
        var columns = 1
        
        // Assume number of rows = number of cards
        var rows = itemCount
        
        repeat {
            let width = size.width / CGFloat(columns)
            let height = width / aspectRatio
            
            if CGFloat(rows) * height < size.height {
                break
            }
            columns += 1
            rows = (itemCount + (columns - 1)) /  columns
        } while columns < itemCount
        
        if columns > itemCount {
            columns = itemCount
        }
        
        return floor(size.width / CGFloat(columns))
    }
}

// items 10
// cols = 1 rows = 10
// cols = 2 rows = (10 + (2-1))/2 = 5.5 = 5 or 10/2 = 5
// cols = 3 rows = (10 + (3-1))/2 = 6       or 10/3 = 3
// cols = 4 rows = (10 + (4-1))/2 = 6       or 10/4 = 2

struct AspectVGrid_Previews: PreviewProvider {
    static var previews: some View {
        AspectVGrid<EmojiMemoryGame.Card, CardView>(items: EmojiMemoryGame().cards, aspectRatio: 2/3) { card in
            CardView(card, colours: [.blue])
        }
    }
}
