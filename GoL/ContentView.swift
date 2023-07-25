//
//  ContentView.swift
//  GoL
//
//  Created by Matthew Goodhart on 7/20/23.
//

import SwiftUI



struct ContentView: View {
    init( _ code: () -> () ) { //using this init to allow for immediate execution of readyArrayOfSquares() on Model.shared
        code()
    }
    
    @ObservedObject var viewModel: Model = Model.shared
    
    var row = 10
    var column = 10
    
    var body: some View {
        
        NavigationView {
            ZStack {
                LinearGradient(colors: [Color("MercuryLime"), .white], startPoint: .topLeading, endPoint: .bottomTrailing)
                    .ignoresSafeArea()
                VStack(alignment: .center) {
                    Text(viewModel.gameState.rawValue) // for debug
                    Spacer()
                    Text(viewModel.instructionalText)
                    Spacer()
                    Text("Current Generation: \(viewModel.iterationNumber)")
                    GameGrid(viewModel: self.viewModel)
                    Spacer()
                    Controls(model: viewModel)
//                    HStack(alignment:.center, spacing: 50 ) { // make spacing a function of device width?
//                        switch viewModel.gameState {
//
//                        case .running:
//                            Button() {
//                                viewModel.gameState = .stopped
//                                print("Pause Button Tapped")
//                            } label: {
//                                Text("Pause")
//                                Image(systemName: "pause.fill")
//                            }
//
//                        case  .stopped, .ready, .iterating:
//                            Button() {
//                                viewModel.startGame()
//                                print("Start Button tapped")
//                            } label: {
//                                Text("Start")
//                                Image(systemName: "play.fill")
//                            }
//                        }
//
//                        if (viewModel.gameState != .running) {
//
//                            Button() {
//                                viewModel.iterate()
//                            } label: {
//                                Text("Advance")
//                                Image(systemName: "forward.end.circle.fill")
//                            }
//                        }
//                        if (viewModel.gameState == .stopped) {
//                            Button() {
//                                print("reset button hit")
//                                viewModel.resetGame()
//                            } label: {
//                                Text("Reset")
//                                Image(systemName: "restart.circle.fill")
//                            }
//                        }
//                    }
                    
                }
                .navigationBarTitle("Conway's Game of Life", displayMode: .large)
            }
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView() {
            Model.shared.squareArray = Model.shared.readyArrayOfSquares()
        }
    }
}

