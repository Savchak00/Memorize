//
//  EmojiMemoryGameView.swift
//  Memorize
//
//  Created by Daniel Savchak on 24.07.2020.
//  Copyright © 2020 Danylo Savchak. All rights reserved.
//

import SwiftUI

struct EmojiMemoryGameView: View {
    @ObservedObject var viewModel: EmojiMemoryGame
    
    
    var body: some View {
        VStack {
            Grid(viewModel.cards) { card in
                    CardView(card: card).onTapGesture {
                        withAnimation(.linear(duration: 0.75)) {
                            self.viewModel.choose(card: card)
                        }
                    }
            .padding(5)
            }
                .foregroundColor(Color(viewModel.themeColor))
                .padding()
            HStack {
                Button(action: {
                    withAnimation(.easeInOut) {
                        self.viewModel.changeTheme()
                    }
                }) {
                    Text("New Game")
                        .foregroundColor(Color.black)
                    .bold()
                    
                }
                .padding(.trailing, 80)
                Text("Score: \(viewModel.score)")
                .padding(.leading, 80)
            }
        }
        .padding()
    }
}

struct CardView: View {
    var card: MemoryGame<String, UIColor>.Card
    
    var body: some View {
        GeometryReader{ geometry in
            self.body(size: geometry.size)
        }
    }
    
    @State private var animatedBonusRemaining: Double = 0
    
    private func startBonusTimeAnimation() {
        animatedBonusRemaining = card.bonusRemaining
        withAnimation(.linear(duration: card.bonusTimeRemaining)){
            animatedBonusRemaining = 0
        }
    }
    
    @ViewBuilder // following are just list of views like html
    private func body(size: CGSize) -> some View {
        if card.isFaceUp || !card.isMatched {
            ZStack {
                Group {
                    if card.isConsumingBonusTime {
                       Pie(startAngle: Angle.degrees(0-90), endingAngle: Angle.degrees(-animatedBonusRemaining*360-90),clockwise: true)
                        .onAppear {
                            self.startBonusTimeAnimation()
                        }
                    } else {
                        Pie(startAngle: Angle.degrees(0-90), endingAngle: Angle.degrees(-card.bonusRemaining*360-90),clockwise: true)
                    }
                }.padding(5).opacity(0.4)
                    .transition(.identity)
                Text(self.card.content)
                    .font(Font.system(size: fontSize(for: size)))
                    .rotationEffect(Angle.degrees(card.isMatched ? 360 : 0))
                    .animation(card.isMatched ? Animation.linear(duration: 1).repeatForever(autoreverses: false) : .default)
                }.aspectRatio(2/3, contentMode: .fit).cardify(isFaceUp: card.isFaceUp)
                .transition(AnyTransition.scale)
        }
    }
    
    //MARK: - Drawing Constants
    
    private func fontSize(for size: CGSize) -> CGFloat {
        min(size.width,size.height) * 0.5
    }
}























//struct ContentView_Previews: PreviewProvider {
//    static var previews: some View {
//        let game = EmojiMemoryGame()
//        game.choose(card: game.cards[2])
//        return EmojiMemoryGameView(viewModel: game)
//    }
//}
