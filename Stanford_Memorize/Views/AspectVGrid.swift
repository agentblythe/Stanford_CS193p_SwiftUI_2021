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
    var spacing: CGFloat
    var content: (Item) -> ItemView
    
    init(items: [Item], aspectRatio: CGFloat, spacing: CGFloat = 5.0, @ViewBuilder content: @escaping (Item) -> ItemView) {
        self.items = items
        self.aspectRatio = aspectRatio
        self.spacing = spacing
        self.content = content
    }
    
    var body: some View {
        GeometryReader { geometry in
            VStack {
                LazyVGrid(columns: [adaptiveGridItem(width: widthThatFits(in: geometry.size))], spacing: spacing) {
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
        gridItem.spacing = spacing
        return gridItem
    }
    
    private func widthThatFits(in size: CGSize) -> CGFloat {
        let itemCount = items.count

        var columns = 1
        var rows = itemCount
        
        var width: CGFloat
        var height: CGFloat
        
        repeat {
            width = (size.width - (spacing * CGFloat(columns - 1))) / CGFloat(columns)
            
            height = width / aspectRatio
            
            if (CGFloat(rows) * height) + (spacing * CGFloat(rows - 1)) < size.height {
                break
            }
            columns += 1
            rows = (itemCount + (columns - 1)) /  columns
            //rows = itemCount /  columns
        } while columns < itemCount
        
        if columns > itemCount {
            columns = itemCount
        }
        
        return floor((size.width - (spacing * CGFloat(columns - 1))) / CGFloat(columns))
    }
}

// How does this algorithm work?
// 1. Assume 1 column and item.count rows, e.g. 1 col, 11 rows
// 2. Calculate width and height based on these values
// 3. If we satisfy the requirement, break out
// 4. If not increment columns and calculat rows
// 5. repeat whil columns < item count
// e.g. 11 items
// cols = 1, rows = 11
// cols = 2, rows = (11 + (2 - 1)) / 2 = 6
// cols = 3, rows = (11 + (3 - 1)) / 3 = 6.5 (= 6)
// cols = 4, rows = (11 + (4 - 1)) / 4 = 3.5 (= 3)
// cols = 5, rows = (11 + (5 - 1)) / 5 = 3
// c.w. just rows = itemcount / cols
// cols = 1, rows = 11
// cols = 2, rows = 11/2 = 5.5 (= 5)
// cols = 3, rows = 11/3 = 3
// cols = 4, rows == 11/4 = 2


struct AspectVGrid_Previews: PreviewProvider {
    static var previews: some View {
        AspectVGrid<EmojiMemoryGame.Card, CardView>(items: EmojiMemoryGame(using: DefaultThemes.all.first!).cards, aspectRatio: 2/3, spacing: 5.0) { card in
            CardView(card, colours: [.blue])
        }
    }
}
