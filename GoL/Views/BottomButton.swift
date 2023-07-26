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
            HStack(alignment: .center, spacing: (UIScreen.main.bounds.width/4)) {
                Button() {
                    viewModel.generateRandomSeed()
                } label : {
                    Text("Random")
                    Image(systemName: "bolt")
                }
                Button() {
                    viewModel.generate15seed()
                } label : {
                    Text("Penta-Decathalon")
                    Image(systemName: "goforward.15")
                }
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
