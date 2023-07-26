//
//  Square.swift
//  GoL
//
//  Created by Matthew Goodhart on 7/23/23.
//

import SwiftUI

struct Square: View {
    
    @ObservedObject var viewModel: Model = Model.shared
    
    let xPosition: Int
    let yPosition: Int
    @State var isAlive: Bool = false // is @State the right binding here, since the Model will also update this property ?
    
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
        let numberOfColumns = 10
        let squareWidth = screenWidth / CGFloat(numberOfColumns + 1)
        
        Rectangle()
            .frame(width: squareWidth, height: squareWidth, alignment: .center)
            .foregroundColor(isAlive == false ? .gray : Color("MercuryLime") )
            .border(.black)
            .onTapGesture {
                if viewModel.gameState == .ready {
                    //if Square is dead when clicked, add it to the liveStartingSquaresArray
                    if !self.isAlive {
                        viewModel.liveStartingSquares.append(Square(xPosition: xPosition, yPosition: yPosition, isAlive: true))
                    } else {
                        //otherwise find the liveStartingSquare matching the tapped square, then remove it from liveStartingSquares
                        let squareIndex = viewModel.liveStartingSquares.firstIndex { ($0.xPosition == self.xPosition) && ($0.yPosition == self.yPosition) }
                        
                        if let squareIndex {
                            viewModel.liveStartingSquares.remove(at: squareIndex)
                        }
                    }
                    self.isAlive.toggle()
                    print("Square \(xPosition), \(yPosition) has been tapped and is now \(isAlive == true ? "alive" : "dead")")
                }
            }
    }
}
