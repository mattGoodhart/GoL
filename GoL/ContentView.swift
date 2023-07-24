//
//  ContentView.swift
//  GoL
//
//  Created by Matthew Goodhart on 7/20/23.
//

import SwiftUI

struct GameGrid: View {
    
    let activeGrid: [Square] = []
    var gameState: GameState = Model.shared.gameState
    
    var rowsCount = 10
    var columnsCount = 10
    var squares: [Square] = Model.shared.squareArray
    
    // @State var startingSquares make this a small array of points
    
    var body: some View {
        
        if gameState == .stopped {
            Grid(alignment: .topLeading, horizontalSpacing: 0, verticalSpacing: 0) {
                ForEach(0..<rowsCount, id: \.self) { row in
                    GridRow(alignment: .firstTextBaseline) {
                        ForEach(0..<columnsCount, id: \.self) { column in
                            squares.first { $0.xPosition == row && $0.yPosition == column }
                            
                            
                            //call each square from the array
                            
                           // Square(xPosition: row, yPosition: column)
                            
                        }
                    }
                }
            }
        }
        else {
            Grid(alignment: .topLeading, horizontalSpacing: 0, verticalSpacing: 0) {
                ForEach(0..<rowsCount, id: \.self) { row in
                    GridRow(alignment: .firstTextBaseline) {
                        ForEach(0..<columnsCount, id: \.self) { column in
                            Square(xPosition: row, yPosition: column)
                        }
                    }
                }
            }
            
        }
    }
}

struct ContentView: View {
    
    @StateObject private var viewModel = Model.shared
        
    var body: some View {
        
        NavigationView {
            ZStack {
                LinearGradient(colors: [Color("MercuryLime"), .white], startPoint: .topLeading, endPoint: .bottomTrailing)
                    .ignoresSafeArea()
                VStack(alignment: .center) {
                    Spacer()
                    if viewModel.gameState == .ready {
                        Text("Please enter a pattern, then press start or advance")
                    } else {
                        Spacer() // need a more fluid way of controlling grid position
                    }
                    Spacer()
                    GameGrid()
                    Spacer()
                    HStack(alignment:.center, spacing: 50 ) { // make spacing a function of device width
                        switch viewModel.gameState {
                        case .running:
                            Button() {
                                viewModel.gameState = .stopped
                                print("Pause Button Tapped")
                            } label: {
                                Text("Pause")
                                Image(systemName: "pause.fill")
                            }
                        case  .stopped, .ready:
                            Button() {
                                viewModel.startGame()
                                print("Start Button tapped")
                            }
                             label: {
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
                .navigationBarTitle("Conway's Game of Life", displayMode: .large)
            }
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}

