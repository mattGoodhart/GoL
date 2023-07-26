//
//  BottomButton.swift
//  GoL
//
//  Created by Matthew Goodhart on 7/26/23.
//

import SwiftUI

struct BottomButton: View {
    
    @ObservedObject var viewModel: Model
    
    var body: some View {
        if viewModel.liveStartingSquares.isEmpty {
            Button() {
                viewModel.generateRandomSeed()
            } label : {
                Text("Seed")
                Image(systemName: "bolt")
            }
        } else if !viewModel.isRunning {
            Button() {
                viewModel.resetGame()
                print("reset button tapped")
            } label: {
                Text("Reset")
                Image(systemName: "restart.circle.fill")
            }
        } else {
            HStack() {
                Image(systemName: "figure.run")
                Image(systemName: "figure.run")
                Image(systemName: "figure.run")
            }
        }
    }
}
