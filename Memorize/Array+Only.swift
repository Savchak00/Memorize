//
//  Array+Only.swift
//  Memorize
//
//  Created by Daniel Savchak on 28.07.2020.
//  Copyright © 2020 Danylo Savchak. All rights reserved.
//

import Foundation

extension Array {
    var only: Element? {
        count == 1 ? first : nil
    }
}
