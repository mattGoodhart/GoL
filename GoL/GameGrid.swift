//
//  GameGrid.swift
//  GoL
//
//  Created by Matthew Goodhart on 7/24/23.
//

import SwiftUI

struct GameGrid: View {
    
    //private var viewModel = Model.shared
    
    var rowsCount = 10
    var columnsCount = 10
   // var gameState = Model.shared.gameState
    var squares: [Square] = Model.shared.squareArray // this is updating, but changes to this are not triggering a redraw...
  //  let readyStateSquareArray: [Square] = Model.shared.readyArrayOfSquares()
    
    var body: some View {
       // Text(viewModel.gameState.rawValue)
        
        //if gameState == .stopped {
            Grid(alignment: .topLeading, horizontalSpacing: 0, verticalSpacing: 0) {
                ForEach(0..<rowsCount, id: \.self) { row in
                    GridRow(alignment: .firstTextBaseline) {
                        ForEach(0..<columnsCount, id: \.self) { column in
                            squares.first { $0.xPosition == row && $0.yPosition == column }
                        }
                    }
                }
            }
//        } else {
//            //A Blank Starting Grid with all Squares in the dead state
//            Grid(alignment: .topLeading, horizontalSpacing: 0, verticalSpacing: 0) {
//                ForEach(0..<rowsCount, id: \.self) { row in
//                    GridRow(alignment: .firstTextBaseline) {
//                        ForEach(0..<columnsCount, id: \.self) { column in
//                            Square(xPosition: row, yPosition: column)
//                        }
//                    }
//                }
//            }
//        }
    }
}
