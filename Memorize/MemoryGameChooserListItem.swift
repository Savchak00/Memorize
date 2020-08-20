//
//  MemoryGameChooserListItem.swift
//  Memorize
//
//  Created by Daniel Savchak on 18.08.2020.
//  Copyright © 2020 Danylo Savchak. All rights reserved.
//

import SwiftUI

struct MemoryGameChooserListItem: View {
    
    @EnvironmentObject var store: MemoryGameStore
    
    var themeid: UUID
    var indexInThemes: Int
    
    @State private var showGameEditor = false
    
    var isEditing: Bool
    
    var body: some View {
        HStack {
            if self.isEditing {
                Image(systemName: "pencil.circle.fill")
                    .foregroundColor(Color(self.store.themes[indexInThemes].themeColor))
                    .imageScale(.large)
                    .padding(.trailing, 5)
                    .onTapGesture {
                        self.showGameEditor = true

                    }
                    .sheet(isPresented: $showGameEditor, content: {
                        GameEditor(showGameEditor: self.$showGameEditor, themeId: self.indexInThemes)
                    })
            }
            VStack(alignment: .leading) {
                Text("\(self.store.themes[indexInThemes].theme.name)").font(Font.system(size: 30)).foregroundColor(isEditing ? Color.black : Color(self.store.themes[indexInThemes].themeColor))
                if self.store.themes[indexInThemes].theme.emojis.count == self.store.themes[indexInThemes].theme.numberOfPairsToShow {
                    Text("All of \(self.store.themes[indexInThemes].theme.emojis.joined())").font(Font.system(size: 20))
                } else {
                    Text("\(self.store.themes[indexInThemes].theme.numberOfPairsToShow) from \(self.store.themes[indexInThemes].theme.emojis.joined())").font(Font.system(size: 20))
                }
            }
        }
    }
}

struct GameEditor: View {
    @EnvironmentObject var store: MemoryGameStore
    
    @Binding var showGameEditor: Bool
    
    let themeId: Int

    @State private var gameName: String = ""
    @State private var newEmojis: String = ""

    var body: some View {
        VStack(spacing: 0) {
            ZStack {
                Text("Game Editor").font(.headline).padding()
                HStack {
                    Spacer()
                    Button(action: {
                        self.showGameEditor = false
                    }, label: { Text("Done") }).padding()
                }
            }
            Divider()
            Form {
                Section {
                    TextField("Game Name", text: $gameName, onEditingChanged: { began in
                        if !began {
                            self.store.renameTheme(from: self.themeId, to: self.gameName)
                        }
                    })
                }
//                Section(header: Text("Add emoji").bold()) {
//                    ZStack {
//                        TextField("Emoji",text: $newEmojis)
//                        HStack {
//                            Spacer()
//                            Button(action: {
//
//                            }, label: {Text("Add")})
//                        }
//                    }
//                }
//                Section(header: HStack {
//                    Text("Emojis").bold()
//                    Spacer()
//                    Text("tap emoji to exclude")
//                }) {
//                    Grid(game!.theme.emojis) { emoji in
//                        Text("\(emoji)").font(Font.system(.largeTitle))
//                    }
//                }
//                Section(header: Text("Card Count").bold()) {
//                    HStack {
//                        Text("\(self.game!.theme.numberOfPairsToShow) Pairs")
//                        Spacer()
//                        Stepper(onIncrement: {}, onDecrement: {}, label: {EmptyView()})
//                    }
//                }
            }
        }
        .onAppear { self.gameName = self.store.themes[self.themeId].theme.name }
    }
}

extension String : Identifiable {
    public var id: String {
        self
    }
    
}
