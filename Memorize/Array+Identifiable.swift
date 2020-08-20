//
//  Array+Identifiable.swift
//  Memorize
//
//  Created by Daniel Savchak on 28.07.2020.
//  Copyright © 2020 Danylo Savchak. All rights reserved.
//

import Foundation

extension Array where Element: Identifiable {
    func firstIndex(mathing: Element) -> Int? {
        for index in 0..<self.count {
            if self[index].id == mathing.id {
                return index
            }
        }
        return nil
    }
}
