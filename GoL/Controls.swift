//
//  Controls.swift
//  GoL
//
//  Created by Matthew Goodhart on 7/25/23.
//

import SwiftUI

struct Controls: View {
    
    init(model: Model) {
        self.viewModel = model
    }
    
    @ObservedObject var viewModel: Model
    
    let spacing = (UIScreen.main.bounds.width/3)
    
    var body: some View {
        HStack(alignment:.center, spacing: spacing ) {
            
            //Button 1
            if viewModel.isRunning {
                Button() {
                    print("Pause Button Tapped")
                    viewModel.isRunning = false
                    viewModel.gameState = .stopped
                } label: {
                    Text("Pause")
                    Image(systemName: "pause.fill")
                }
            } else {
                Button() {
                    print("Run Button tapped")
                    viewModel.isRunning = true
                    viewModel.iterate()  // Putting iterate here before rungame() is a hacky way to get around the 0.5 second wait for an iteration after hitting run
                    viewModel.runGame()
                } label: {
                    Text("Run")
                    Image(systemName: "play.fill")
                }
            }

            //Button 2
            if !viewModel.isRunning {
                Button() {
                    viewModel.iterate()
                } label: {
                    Text("Advance")
                    Image(systemName: "forward.end.circle.fill")
                }
            }
        }
    }
}


