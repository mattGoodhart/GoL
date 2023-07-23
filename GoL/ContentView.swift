//
//  ContentView.swift
//  GoL
//
//  Created by Matthew Goodhart on 7/20/23.
//

import SwiftUI

struct Square: View {
    
    let xPosition: Int
    let yPosition: Int
    @State var isAlive: Bool = false
    var gameState: GameState = Model.shared.gameState

    
    public func isNeighbor(to square: Square) -> Bool {

        // using abolute value minimizes cases to test due to symmetry
        let xDistance = abs(self.xPosition - square.xPosition)
        let yDistance = abs(self.yPosition - square.yPosition)
        
        switch (xDistance, yDistance) {
        case (1, 1), (0, 1), (1, 0):
            return true
        default:
            return false
        }
    }
    
    var body: some View {
       // var liveStartingSquares: [Square] = []
        let screenWidth = UIScreen.main.bounds.width
        var numberOfColumns = 10
        
        let squareWidth = screenWidth / CGFloat(numberOfColumns + 1)
        Rectangle()
            .frame(width: squareWidth, height: squareWidth, alignment: .center)
            .foregroundColor(isAlive == false ? .gray : Color("MercuryLime") )
            .border(.black)
            .onTapGesture {
                if gameState == .ready {
                    self.isAlive.toggle()
                    print("Square \(xPosition), \(yPosition) is now \(isAlive == true ? "alive" : "dead")")
                    //add this square to a "liveStartingSquares" array that the Model sees.
                    Model.shared.liveStartingSquares.append(Square(xPosition: xPosition, yPosition: yPosition, isAlive: true))
                }
                
            }
    }
}

struct TestGameGrid: View {

    var rowsCount = 10
    var columnsCount = 10
    var squares: [Square] = []
    
    var body: some View {
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

struct GameGrid: View {
    
    let activeGrid: [Square] = []
    var gameState: GameState = Model.shared.gameState
    
    var rowsCount = 10
    var columnsCount = 10
    @State var squares: [Square] = Model.shared.squareArray
    
    // @State var startingSquares make this a small array of points
    
    var body: some View {
        
        if gameState != .ready {
            Grid(alignment: .topLeading, horizontalSpacing: 0, verticalSpacing: 0) {
                ForEach(0..<rowsCount, id: \.self) { row in
                    GridRow(alignment: .firstTextBaseline) {
                        ForEach(0..<columnsCount, id: \.self) { column in
                            squares.first { $0.xPosition == row && $0.yPosition == column }
                            // let arrangedSquares = squares.filter { $0.xPosition == row && $0.yPosition == column }
                            // arrangedSquares.first(where: <#T##(Square) throws -> Bool#>)
                            
                            //call each square from the array
                            
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
    
  //  @State var gameState: GameState = Model.shared.gameState
//    var buttonLabel: String = "Start"
  //  @State var startingGrid: [Square] = Model.shared.liveStartingSquares
  //  @State var squares = Model.shared.squareArray
    
    
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
                    HStack(alignment:.center, spacing: 50 ) {
                        switch viewModel.gameState {
                        case .running:
                            Button() {
                                //pause game
                                print("game pausing")
                            } label: {
                                Text("Pause")
                                Image(systemName: "pause.fill")
                            }
                        case  .stopped, .ready:
                            Button() {
                              //  startGame()
                                print("game starting")
                            }
                             label: {
                                Text("Start")
                                Image(systemName: "play.fill")
                            }
                        }
                        
                        if (viewModel.gameState != .running) {
                            Button() {
                               // $viewModel.iterate
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


//extension ContentView {
//    @MainActor class Model: ObservableObject {
//        @Published var gameState: GameState = .ready
//        @Published var squareArray: [Square] = []
//    }
//}
