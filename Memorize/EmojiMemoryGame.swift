//
//  EmojiMemoryGame.swift
//  Memorize
//
//  Created by Daniel Savchak on 25.07.2020.
//  Copyright © 2020 Danylo Savchak. All rights reserved.
//

import SwiftUI
import Combine

class EmojiMemoryGame: ObservableObject, Identifiable, Hashable {
    
    static func == (lhs: EmojiMemoryGame, rhs: EmojiMemoryGame) -> Bool {
        lhs.id == rhs.id
    }
    
    let id: UUID
    
    func hash(into hasher: inout Hasher) {
        hasher.combine(id)
    }
    
    
    
    @Published private var model: MemoryGame<String, UIColor>
    //every time when model will change, it calls objectWillChange.send()

    init(id: UUID? = nil, theme: EmojiMemoryGameTheme) {
        self.id = id ?? UUID()
        self.theme = theme
        model = EmojiMemoryGame.createMemoryGame(theme: theme)
    }
    
    init(id: UUID? = nil) {
        self.id = id ?? UUID()
        let defaultsKey = "EmojiMemoryGame.\(self.id.uuidString)"
        let theme = EmojiMemoryGameTheme(json: UserDefaults.standard.data(forKey: defaultsKey))
        self.theme = theme ?? EmojiMemoryGameTheme()
        model = EmojiMemoryGame.createMemoryGame(theme: theme!)
    }
    
    @Published var theme: EmojiMemoryGameTheme
    
    private static func createMemoryGame(theme: EmojiMemoryGameTheme) -> MemoryGame<String, UIColor> {
        let jsonData = try? JSONEncoder().encode(theme)
        let jsonStr = String(data: jsonData!, encoding: .utf8)!
        print(jsonStr)
        
        return MemoryGame<String, UIColor>(numberOfPairsOfCards: theme.numberOfPairsToShow, name: theme.name, color: UIColor(red: theme.color.red, green: theme.color.green, blue: theme.color.blue, alpha: theme.color.alpha)) { pairIndex in
            return theme.emojis[pairIndex]
        }
    }
    
    // MARK: - Access to the Model
    
    var cards: Array<MemoryGame<String, UIColor>.Card> {
        return model.cards
    }
    
    var themeName: String {
        return model.nameOfGame
    }
    
    var themeColor: UIColor {
        return model.foregroundColor
    }
    
    var score: Int {
        return model.score
    }
    
    // MARK: - Intent(s)
    
    func choose(card: MemoryGame<String, UIColor>.Card) {
        model.choose(card: card)
    }
    
    func changeTheme() {
        model = EmojiMemoryGame.createMemoryGame(theme: theme)
    }
    
    func renameTheme(to newName: String) {
        self.theme.name = newName
    }
}
