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
    
    var viewModel: Model
    
    var body: some View {
        HStack(alignment: .center, spacing: 50) {
            switch viewModel.gameState {
            case .running:
                Button() {
                    viewModel.gameState = .stopped
                    print("Pause Button Tapped")
                } label: {
                    Text("Pause")
                    Image(systemName: "pause.fill")
                }
                
            case  .stopped, .ready, .iterating:
                Button() {
                    viewModel.startGame()
                    print("Start Button tapped")
                } label: {
                    Text("Start")
                    Image(systemName: "play.fill")
                }
            }
            
            if (viewModel.gameState != .running) {
                
                Button() {
                    viewModel.iterate()
                } label: {
                    Text("Advance")
                    Image(systemName: "forward.end.circle.fill")
                }
            }
            if (viewModel.gameState == .stopped) {
                Button() {
                    print("reset button hit")
                    viewModel.resetGame()
                } label: {
                    Text("Reset")
                    Image(systemName: "restart.circle.fill")
                }
            }
        }
    }
}


