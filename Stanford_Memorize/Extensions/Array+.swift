//
//  Array+.swift
//  Stanford_Memorize
//
//  Created by Steve Blythe on 17/07/2021.
//

import Foundation

extension Array {
    var oneAndOnly: Element? {
        return count == 1 ? first : nil
    }
}
