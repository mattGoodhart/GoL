//
//  Model.swift
//  GoL
//
//  Created by Matthew Goodhart on 7/21/23.
//

import Foundation
import SwiftUI

class Model: ObservableObject {
    
    static let shared = Model()
    
  //  init(initialGrid: [Square]){}
    
    @Published var squareArray: [Square] = []
    // @Published var gameState: GameState = .ready
    var liveStartingSquares: [Square] = []
    @Published var gameState: GameState  = .ready// i think only needed to send EoG to UI...
    
    func startGame() {
        
        // iterate continually unless game comes to an end (all cells dead), or game is reset bhy user
        
    }
    
    func readyArrayOfSquares() -> [Square] {
        var rowsCount = 10
        var columnsCount = 10
        var squares: [Square] = []
        
        for row in 0..<rowsCount {
            for column in 0..<columnsCount {
                squares.append(Square(xPosition: row, yPosition: column))
            }
        }
        return squares
    }
    
    
    
    
    func resetGame() {
        gameState = .ready
    }
    
    
    func iterate() {
        let readyArray: [Square] = readyArrayOfSquares()
        var bufferArrayOfSquares: [Square] = []
        var updatedArrayOfSquares: [Square] = []
        var livingSquaresAfterUpdate: [Square] = []
        
        // if game is just beginning use ready array, if in progress, use last bufferArray
        if gameState == .ready {
            bufferArrayOfSquares = readyArray
            gameState = .running
        }
        
        // For all Squares:
        //first, generate a grid based on initial squares.. map or filter
        guard !liveStartingSquares.isEmpty else {
            print("Live Starting Squares not Found, resetting")
            resetGame()
            return
        }
        
        for startingSquare in liveStartingSquares {
            if let index = bufferArrayOfSquares.firstIndex(where: {($0.xPosition == startingSquare.xPosition) && ($0.yPosition == startingSquare.yPosition)}) {
                bufferArrayOfSquares[index] = Square(xPosition: startingSquare.xPosition, yPosition: startingSquare.yPosition, isAlive: true)
            }
        }
       
        let liveSquares = bufferArrayOfSquares.filter { $0.isAlive == true }
        
        
        // apply rules of game to each square in a buffer set / array. Turn this into a nicer switch.
        for square in bufferArrayOfSquares {
            let aliveNeighbors = liveSquares.filter { $0.isNeighbor(to: square) }
            
            switch (square.isAlive, aliveNeighbors.count) {
            case (true, 2), (true, 3):
                print("Square (\(square.xPosition), \(square.yPosition)) survived.")
                updatedArrayOfSquares.append(square)
                livingSquaresAfterUpdate.append(square)
            case (false, 3):
                print("Square (\(square.xPosition), \(square.yPosition)) was born.")
                square.isAlive = true
                updatedArrayOfSquares.append(square)
                livingSquaresAfterUpdate.append(square)
                
            default:
                print("Square (\(square.xPosition), \(square.yPosition)) is dead.")
                updatedArrayOfSquares.append(square)
            }
           /*
            // Any live cell with two or three live neighbors lives on to the next generation.
            if square.isAlive && (aliveNeighbors.count == 2 || aliveNeighbors.count == 3) {
                print("Square (\(square.xPosition), \(square.yPosition)) survived.")
                updatedArrayOfSquares.append(square)
                livingSquaresAfterUpdate.append(square)
                
            //Any dead cell with exactly 3 live neighbors becomes a live cell, as if by reproduction.
            } else if !square.isAlive && aliveNeighbors.count == 3 {
                print("Square (\(square.xPosition), \(square.yPosition)) was born.")
                square.isAlive = true
                updatedArrayOfSquares.append(square)
                livingSquaresAfterUpdate.append(square)
                
                
                
            //All other live cells die in the next generation. All other dead cells stay dead.
            } else {
              //  print("Square (\(square.xPosition), \(square.yPosition)) is dead.")
                guard square.isAlive == false else {
                    print("Square (\(square.xPosition), \(square.yPosition)) stays dead.")
                    updatedArrayOfSquares.append(square)
                    return
                }
                print("Square (\(square.xPosition), \(square.yPosition)) dies.")
                square.isAlive = false
                updatedArrayOfSquares.append(square)
                
            } */
        }
        
        let isGameOver: Bool = livingSquaresAfterUpdate.count == 0
        
        if isGameOver {
            gameState = .ready
        } else {
            gameState = .stopped
        }
        
        squareArray = updatedArrayOfSquares
        // after all squares processed:
        //check if game is over
        //transform the array / set into GridItems that can be used in the UI
        
        
        
        
    }
}

enum GameState {
    case ready
    case running
    case stopped
}

    

