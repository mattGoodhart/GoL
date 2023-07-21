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
    
    public func isNeighbor(to square: Square) -> Bool {

        // using abolute value minimizes cases to test
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
        let screenWidth = UIScreen.main.bounds.width
        var numberOfColumns = 10
        
        let squareWidth = screenWidth / CGFloat(numberOfColumns + 1)
        Rectangle()
            .frame(width: squareWidth, height: squareWidth, alignment: .center)
            .foregroundColor(isAlive == false ? .gray : Color("MercuryLime") )
            .border(.black)
            .onTapGesture {
                if self.isAlive == false {
                    self.isAlive = true
                } else {
                    self.isAlive = false
                }
            }
    }
}

struct GameGrid: View {

    var rowsCount = 10
    var columnsCount = 10
    
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

struct ContentView: View {
    
    var body: some View {
        
        NavigationView {
            ZStack {
                LinearGradient(colors: [Color("MercuryLime"), .white], startPoint: .topLeading, endPoint: .bottomTrailing)
                    .ignoresSafeArea()
                VStack(alignment: .trailing) {
                    GameGrid()
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
