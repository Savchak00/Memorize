//
//  EmojiMemoryGameTheme.swift
//  Memorize
//
//  Created by Daniel Savchak on 31.07.2020.
//  Copyright © 2020 Danylo Savchak. All rights reserved.
//

import Foundation
import SwiftUI

struct EmojiMemoryGameTheme: Codable {
    var name: String
    var emojis: [String]
    var numberOfPairsToShow: Int
    var color: UIColor.RGB

    
    init() {
        self.name = "New theme"
        self.emojis = [""]
        self.color = UIColor.RGB(red: 0, green: 0, blue: 0, alpha: 0)
        self.numberOfPairsToShow = 0
    }
    
    init(name: String, emojis: [String], color: UIColor.RGB) {
        self.name = name
        self.emojis = emojis
        self.color = color
        self.numberOfPairsToShow = emojis.count
    }
    
    init(name: String, emojis: [String], color: UIColor.RGB, numberOfPairsToShow: Int) {
        self.name = name
        self.emojis = emojis
        self.color = color
        if numberOfPairsToShow > emojis.count{
            self.numberOfPairsToShow = emojis.count
        } else {
            self.numberOfPairsToShow = numberOfPairsToShow
        }
    }
    
    mutating func changeName(newName: String) {
        self.name = newName
        print("\(self.name)")
    }
    
    var json: Data? {
        return try? JSONEncoder().encode(self)
    }
    
    init?(json: Data?) {
        if json != nil, let newTheme = try? JSONDecoder().decode(EmojiMemoryGameTheme.self, from: json!) {
            self = newTheme
        } else {
            return nil
        }
    }
}


extension Color {
    init(_ rgb: UIColor.RGB) {
        self.init(UIColor(rgb))
    }
}
extension UIColor {
    public struct RGB: Hashable, Codable {
        var red: CGFloat
        var green: CGFloat
        var blue: CGFloat
        var alpha: CGFloat
    }
    
    convenience init(_ rgb: RGB) {
        self.init(red: rgb.red, green: rgb.green, blue: rgb.blue, alpha: rgb.alpha)
    }
    
    public var rgb: RGB {
        var red: CGFloat = 0
        var green: CGFloat = 0
        var blue: CGFloat = 0
        var alpha: CGFloat = 0
        getRed(&red, green: &green, blue: &blue, alpha: &alpha)
        return RGB(red: red, green: green, blue: blue, alpha: alpha)
    }
}
