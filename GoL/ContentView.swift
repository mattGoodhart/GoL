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
    
    var body: some View {
        
        NavigationView {
            ZStack {
                LinearGradient(colors: [Color("MercuryLime"), .white], startPoint: .topLeading, endPoint: .bottomTrailing)
                    .ignoresSafeArea()
                VStack(alignment: .center) {

                        Spacer()
                        Text("Generation: \(viewModel.iterationNumber)")
                        .font(.title.bold())
                        .foregroundColor(.white)
                        
                        
                        GameGrid(viewModel: self.viewModel)
                        Controls(model: viewModel)
                        Spacer()
                        
                        //The Bottom Button
                        if viewModel.liveStartingSquares.isEmpty {
                            Button() {
                                viewModel.generateRandomSeed()
                            } label : {
                                Text("Seed")
                                Image(systemName: "bolt")
                            }
                        } else {
                            Button() {
                                viewModel.resetGame()
                                print("reset button tapped")
                            } label: {
                                Text("Reset")
                                Image(systemName: "restart.circle.fill")
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
        ContentView() {
            Model.shared.squareArray = Model.shared.readyArrayOfSquares()
        }
    }
}

