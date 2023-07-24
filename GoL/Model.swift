//
//  Model.swift
//  GoL
//
//  Created by Matthew Goodhart on 7/21/23.
//

import SwiftUI

class Model: ObservableObject {
    
    static let shared = Model()
    var liveStartingSquares: [Square] = [] // these are the squares chosen by the user before starting the game
    
    @Published var squareArray: [Square] = []
    @Published var gameState: GameState  = .ready
    @Published var iterationNumber: Int = 0
    
    func startGame() {
        
        gameState = .running
        
        for _ in (0..<9999) {
            guard gameState != .ready else {
                return
            }
            iterate()
            sleep(500)
            iterationNumber += 1
            
        }
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
        liveStartingSquares = []
        gameState = .ready
        iterationNumber = 0
    }
    
    
    func iterate() {
        let readyArray: [Square] = readyArrayOfSquares()
        var bufferArrayOfSquares: [Square] = []
        var updatedArrayOfSquares: [Square] = []
        var livingSquaresAfterUpdate: [Square] = []
      //  var neighborMap: [: [Square]]
        
        
        // if game is just beginning use ready array, if in progress, use last bufferArray
        if gameState == .ready {
            bufferArrayOfSquares = readyArray
            gameState = .running
        } else {
            bufferArrayOfSquares = updatedArrayOfSquares
        }
        
      //  let liveSquaresInModelAtBeginningOfIteration = bufferArrayOfSquares.filter { $0.isAlive == true } // I'm misusing filter?
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

        //at this point, bufferArrayOfSquares represents the grid after user input. so good.
        var aliveNeighborsArray: [Int] = []
        
        for square in bufferArrayOfSquares {
            let aliveNeighbors = liveStartingSquares.filter { $0.isNeighbor(to: square) } // alive neighbors might be blank
            aliveNeighborsArray.append(aliveNeighbors.count) // for debugging
            switch (square.isAlive, aliveNeighbors.count) { //seems switch always hits default
                
                // Any live cell with two or three live neighbors lives on to the next generation.
            case (true, 2), (true, 3):
                print("Square (\(square.xPosition), \(square.yPosition)) survived.")
                updatedArrayOfSquares.append(square)
                livingSquaresAfterUpdate.append(square)
                //Any dead cell with exactly 3 live neighbors becomes a live cell, as if by reproduction.
            case (false, 3):
                print("Square (\(square.xPosition), \(square.yPosition)) was born.")
                let newSquare = Square(xPosition: square.xPosition, yPosition: square.yPosition, isAlive: true)
                
                //square.isAlive = true
                updatedArrayOfSquares.append(newSquare)
                livingSquaresAfterUpdate.append(newSquare)
                //All other live cells die in the next generation. All other dead cells stay dead.
            default:
                print("Square (\(square.xPosition), \(square.yPosition)) is dead.")
                if square.isAlive {
                    let newSquare = Square(xPosition: square.xPosition, yPosition: square.yPosition, isAlive: false)
                  //  square.isAlive.toggle()
                    updatedArrayOfSquares.append(newSquare)
                } else {
                    updatedArrayOfSquares.append(square)
                }
            }
            /*
             
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
        // livingSqauresAfterUpdate is choosing the correct squares, but they are not getting activated?
        let isGameOver: Bool = livingSquaresAfterUpdate.count == 0
        
        if isGameOver {
            gameState = .ready
        } else {
            gameState = .stopped
        }
        
        //updatedArrayOfSquares seems to be returning an unltered array still
        
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



