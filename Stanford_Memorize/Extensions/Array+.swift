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

extension Array where Element:Identifiable {
    func firstIndex(matching: Element) -> Int? {
        for index in 0..<self.count {
            if self[index].id == matching.id {
                return index
            }
        }
        return nil
    }
}
