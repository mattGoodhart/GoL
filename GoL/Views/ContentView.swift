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
    @State private var showingInfo: Bool = false
    
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
                    TopControls(viewModel: self.viewModel)
                    Spacer()
                    BottomButton(viewModel: self.viewModel)
                }
                .navigationBarTitle("Conway's Game of Life", displayMode: .large)
                .navigationBarItems(
                    trailing: Button() {
                        showingInfo.toggle()
                    } label: {
                        Image(systemName: "info.circle.fill")
                    })
                .sheet(isPresented: $showingInfo) {
                    InfoView()
                }
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

