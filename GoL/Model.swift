//
//  Model.swift
//  GoL
//
//  Created by Matthew Goodhart on 7/21/23.
//

import SwiftUI

class Model: ObservableObject {
    
    static let shared = Model()
    
    var liveStartingSquares: [Square] = [] //the squares chosen by the user before starting the game
    
    @Published var squareArray: [Square] = [] // The array sent to the UI at the end of iteration. Updating this should trigger a grid redraw but doesnt seem to.
    @Published var gameState: GameState  = .ready //Updating this should update button states and text in UI
    @Published var iterationNumber: Int = 0 // Updating should increment the generation counter. may not be necessary to publish? since it will change with squareArray
    
    func startGame() {
        
        gameState = .running
        
        for _ in (0..<9999) { //Make this look more like an autosave
            //            guard gameState != .ready else {
            //                return
            //            }
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
        squareArray = readyArrayOfSquares()
        gameState = .ready
        iterationNumber = 0
    }
    
    
    func iterate() {
        
        var bufferArrayOfSquares: [Square] = [] //the array of Squares to process
        var updatedArrayOfSquares: [Square] = [] //Squares after processing
        var livingSquaresAfterUpdate: [Square] = [] //the living Squares after last iteration
        
        bufferArrayOfSquares = squareArray // this squareArray is initialized with a blank Square array in GoLApp
        
        if iterationNumber == 0 {
            guard !liveStartingSquares.isEmpty else {
                print("Live Starting Squares not Found, resetting")
                resetGame()
                return
            }
        }
        gameState = .iterating
        
        if iterationNumber == 0 {
            for startingSquare in liveStartingSquares {
                if let index = bufferArrayOfSquares.firstIndex(where: {($0.xPosition == startingSquare.xPosition) && ($0.yPosition == startingSquare.yPosition)}) {
                    bufferArrayOfSquares[index] = Square(xPosition: startingSquare.xPosition, yPosition: startingSquare.yPosition, isAlive: true)
                }
            }
        }
        
        var aliveNeighborsArray: [Square] = []
        
        for square in bufferArrayOfSquares {
            if iterationNumber == 0 {
                aliveNeighborsArray = liveStartingSquares.filter { $0.isNeighbor(to: square) }
            } else {
                //check for neighbors of last iteration
                let aliveFromLastIteration = squareArray.filter { $0.isAlive }//lastIterationSquares.filter { $0.isAlive }
                aliveNeighborsArray = aliveFromLastIteration.filter { $0.isNeighbor(to: square) }
            }
            
            switch (square.isAlive, aliveNeighborsArray.count) { //seems switch always hits default
                
                // Any live cell with two or three live neighbors lives on to the next generation.
            case (true, 2), (true, 3):
                //  print("Square (\(square.xPosition), \(square.yPosition)) survived.")
                updatedArrayOfSquares.append(square)
                livingSquaresAfterUpdate.append(square)
                
                //Any dead cell with exactly 3 live neighbors becomes a live cell, as if by reproduction.
            case (false, 3):
                //   print("Square (\(square.xPosition), \(square.yPosition)) was born.")
                let newSquare = Square(xPosition: square.xPosition, yPosition: square.yPosition, isAlive: true)
                updatedArrayOfSquares.append(newSquare)
                livingSquaresAfterUpdate.append(newSquare)
                
                //All other live cells die in the next generation. All other dead cells stay dead.
            default:
                //  print("Square (\(square.xPosition), \(square.yPosition)) is dead.")
                if square.isAlive {
                    let newSquare = Square(xPosition: square.xPosition, yPosition: square.yPosition, isAlive: false)
                    updatedArrayOfSquares.append(newSquare)
                } else {
                    updatedArrayOfSquares.append(square)
                }
            }
        }
        // DEBUG
        var positionsOfLivingSquaresAfterUpdate: [String] = []
        for square in livingSquaresAfterUpdate {
            positionsOfLivingSquaresAfterUpdate.append("(\(square.xPosition), \(square.yPosition))")
        }
        print(positionsOfLivingSquaresAfterUpdate)
        // End of DEBUG... why isn't my view updating beyond first iteration?
        
        squareArray = updatedArrayOfSquares
        
        iterationNumber += 1
        
        let isGameOver: Bool = livingSquaresAfterUpdate.count == 0
        
        if isGameOver {
            gameState = .ready
        } else {
            gameState = .stopped
        }
    }
}

enum GameState: String {
    case ready = "Ready"
    case running = "Running"
    case iterating = "Iterating"
    case stopped = "Stopped"
}



