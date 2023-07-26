//
//  GameGrid.swift
//  GoL
//
//  Created by Matthew Goodhart on 7/24/23.
//

import SwiftUI

struct GameGrid: View {

    var viewModel: Model
    var squares: [Square] = Model.shared.squareArray
    
    var body: some View {
        
        Grid(alignment: .topLeading, horizontalSpacing: 0, verticalSpacing: 0) {
            ForEach(0..<20) { row in
                GridRow(alignment: .firstTextBaseline) {
                    ForEach(0..<20) { column in
                        viewModel.squareArray.first { $0.xPosition == row && $0.yPosition == column }
                            .id(UUID())
                    }
                }
            }
        }
    }
}
