//
//  ColourChoice.swift
//  Stanford_Memorize
//
//  Created by Steve Blythe on 27/12/2021.
//

import SwiftUI

struct ColourChoice: View {
    let colour: ValidColour
    
    var body: some View {
        Circle()
            .foregroundColor(Color(validColour: colour))
            .overlay(Circle().stroke(lineWidth: 2))
    }
}

struct ColourChoice_Previews: PreviewProvider {
    static var previews: some View {
        ColourChoice(colour: .red)
    }
}
