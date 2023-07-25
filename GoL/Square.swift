//
//  Square.swift
//  GoL
//
//  Created by Matthew Goodhart on 7/23/23.
//

import SwiftUI

struct Square: View {
    
    let xPosition: Int
    let yPosition: Int
    @State var isAlive: Bool = false
   // var gameState: GameState = Model.shared.gameState
    
    
    public func isNeighbor(to square: Square) -> Bool {
        
        // using abolute value minimizes cases to test due to symmetry
        let xDistance = abs(self.xPosition - square.xPosition)
        let yDistance = abs(self.yPosition - square.yPosition)
        
        switch (xDistance, yDistance) {
        case (1, 1), (0, 1), (1, 0):
            return true
        default:
            return false
        }
    }
    
    var body: some View {
        
        let screenWidth = UIScreen.main.bounds.width
        var numberOfColumns = 10
        
        let squareWidth = screenWidth / CGFloat(numberOfColumns + 1)
        Rectangle()
            .frame(width: squareWidth, height: squareWidth, alignment: .center)
            .foregroundColor(isAlive == false ? .gray : Color("MercuryLime") )
            .border(.black)
            .onTapGesture {
              //  if gameState == .ready {
                    self.isAlive.toggle()
                    print("Square \(xPosition), \(yPosition) has been tapped and is now \(isAlive == true ? "alive" : "dead")")
                    Model.shared.liveStartingSquares.append(Square(xPosition: xPosition, yPosition: yPosition, isAlive: true))
              //  }
            }
    }
}
