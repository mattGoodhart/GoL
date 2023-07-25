//
//  GameGrid.swift
//  GoL
//
//  Created by Matthew Goodhart on 7/24/23.
//

import SwiftUI

struct GameGrid: View {
    
    init(viewModel: Model) {
        self.viewModel = viewModel
    }
    
    var viewModel: Model
    
    var rowsCount = 10
    var columnsCount = 10
    var squares: [Square] = Model.shared.squareArray // this is updating, but changes to this are not triggering a redraw...
    //  let readyStateSquareArray: [Square] = Model.shared.readyArrayOfSquares()
    
    var body: some View {
        
        Grid(alignment: .topLeading, horizontalSpacing: 0, verticalSpacing: 0) {
            ForEach(0..<10) { row in
                GridRow(alignment: .firstTextBaseline) {
                    ForEach(0..<10) { column in
                        viewModel.squareArray.first { $0.xPosition == row && $0.yPosition == column }
                            .id(UUID()) // should maybe change data structure to avoid this?
                    }
                }
            }
        }
    }
}
