//
//  MemoryGameChooser.swift
//  Memorize
//
//  Created by Daniel Savchak on 18.08.2020.
//  Copyright © 2020 Danylo Savchak. All rights reserved.
//

import SwiftUI

struct MemoryGameChooser: View {
    
    @EnvironmentObject var store: MemoryGameStore
    
    @State private var editMode: EditMode = .inactive
    var body: some View {
        NavigationView {
            List {
                ForEach(0..<self.store.themes.count, id:\.self) { index in
                    NavigationLink(destination: EmojiMemoryGameView(viewModel: self.store.themes[index])
                        .navigationBarTitle(self.store.themes[index].theme.name)
                    ) {
                        MemoryGameChooserListItem(indexInThemes: index, isEditing: self.editMode.isEditing)
                    }
                }
                .onDelete { indexSet in
                    indexSet.map { self.store.themes[$0] }.forEach { game in
                        self.store.removeGame(game)
                    }
                }
            }
            .navigationBarTitle(self.store.name)
            .navigationBarItems(leading: Button(action: {
                self.store.addGame()
            },label: {
                Image(systemName: "plus").imageScale(.large)
            }),
                trailing: EditButton()
            )
            .environment(\.editMode, $editMode)
        }
    }
}
