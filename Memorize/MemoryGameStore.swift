//
//  MemoryGameStore.swift
//  Memorize
//
//  Created by Daniel Savchak on 18.08.2020.
//  Copyright © 2020 Danylo Savchak. All rights reserved.
//

import SwiftUI
import Combine

class MemoryGameStore: ObservableObject {
    let name: String
    
    func name(for document: EmojiMemoryGame) -> String {
        for theme in themes {
            if theme.themeName == document.themeName {
                return theme.themeName
            }
        }
        return "Untitled"
    }
    
    func addGame(named name: String = "Untitled") {
        themes.append(EmojiMemoryGame(id: UUID(), theme: EmojiMemoryGameTheme(name: name, emojis: ["🏳️","🏴","🏁"], color: UIColor.RGB(red: 0, green: 0, blue: 0, alpha: 1))))
    }
    
    func removeGame(_ game: EmojiMemoryGame) {
        for (index,model) in themes.enumerated() {
            if model.id == game.id { themes.remove(at: index); return }
        }
    }
    
    func renameTheme(from id: Int ,to newName: String) {
        themes[id].theme.changeName(newName: newName)
        print(themes[id].theme.name)
    }
    
    
    @Published var themes: [EmojiMemoryGame] = [
        EmojiMemoryGame(id: UUID(), theme: EmojiMemoryGameTheme(name: "Halloween", emojis: ["👻","🎃","🕷","🦇","🌑","😈"], color: UIColor.RGB(red:1,green:0,blue:0,alpha:1))),
        EmojiMemoryGame(id: UUID(), theme: EmojiMemoryGameTheme(name: "Animals", emojis: ["🐶","🐢","🐒","🐝","🦀","🐓"], color: UIColor.RGB(red:0,green:0,blue:1,alpha:1))),
        EmojiMemoryGame(id: UUID(), theme: EmojiMemoryGameTheme(name: "Sport", emojis: ["⚽️","🏈","🥊","🏄🏿‍♂️","🪂","🚴🏿"], color: UIColor.RGB(red:0,green:1,blue:0,alpha:1))),
        EmojiMemoryGame(id: UUID(), theme: EmojiMemoryGameTheme(name: "Food", emojis: ["🍔","🍎","🍏","🍣","🍰","🧅"], color: UIColor.RGB(red:1,green:0,blue:1,alpha:1))),
        EmojiMemoryGame(id: UUID(), theme: EmojiMemoryGameTheme(name: "Clock", emojis: ["🕐","🕑","🕛","🕤","🕓","🕥"], color: UIColor.RGB(red:128/255,green:128/255,blue:128/255,alpha:1))),
        EmojiMemoryGame(id: UUID(), theme: EmojiMemoryGameTheme(name: "Faces", emojis: ["😀","😄","😃","😊","😋","😡"], color: UIColor.RGB(red:1,green:1,blue:0,alpha:1)))
        ] {
        willSet {
            print(newValue)
        }
    }
    
    private var autosave: AnyCancellable?
    
    init(named name: String = "Memory Game") {
        self.name = name
        let defaultsKey = "MemoryGame.\(name)"
        if let newThemes = UserDefaults.standard.object(forKey: defaultsKey) as? [EmojiMemoryGame] {
            themes = newThemes
        }
        autosave = $themes.sink { themes in
            UserDefaults.standard.set(themes.asPropertyList, forKey: defaultsKey)
        }
    }
    
}

extension Array where Element == EmojiMemoryGame {
    var asPropertyList: [String] {
        var uuids = [String]()
        for value in self {
            uuids += value.id.uuidString.map(String.init)
        }
        return uuids
    }
    
    init(fromPropertyList plist: Any?) {
        self.init()
        let uuids = plist as? [String] ?? []
        for uuid in uuids {
            self += [EmojiMemoryGame(id: UUID(uuidString: uuid))]
        }
    }
}
