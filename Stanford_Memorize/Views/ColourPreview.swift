//
//  ColourPreview.swift
//  Stanford_Memorize
//
//  Created by Steve Blythe on 27/12/2021.
//

import SwiftUI

struct ColourPreview: View {
    let colours: [ValidColour]
    
    var body: some View {
        if colours.count == 0 || colours.count > 2 {
            RoundedRectangle(cornerRadius: DrawingConstants.roundedRectangleRadius)
                .foregroundColor(.clear)
                .overlay(overlayRect)
        } else if colours.count == 1 {
            RoundedRectangle(cornerRadius: DrawingConstants.roundedRectangleRadius)
                .foregroundColor(Color(validColour: colours.first!))
                .overlay(overlayRect)
        } else {
            RoundedRectangle(cornerRadius: DrawingConstants.roundedRectangleRadius)
                .gradientForeground(colors: colours.map({ col in
                    Color(validColour: col)
                }))
                .overlay(overlayRect)
        }
    }
    
    var overlayRect: some View {
        RoundedRectangle(cornerRadius: DrawingConstants.roundedRectangleRadius).strokeBorder(lineWidth: DrawingConstants.strokeWidth)
    }
}

struct ColourPreview_Previews: PreviewProvider {
    static var previews: some View {
        ColourPreview(colours: [.red, .blue])
    }
}
