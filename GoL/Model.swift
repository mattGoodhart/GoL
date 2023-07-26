//
//  Model.swift
//  GoL
//
//  Created by Matthew Goodhart on 7/21/23.
//

import SwiftUI

class Model: ObservableObject {
    
    static let shared = Model()
    
    @Published var isRunning: Bool = false // Flag that indicates if game is autorunning
    @Published var isSeeded: Bool = false // Indicates if the user chose to generate a random seed
    @Published var liveStartingSquares: [Square] = [] //the squares chosen by the user before starting the game
    @Published var squareArray: [Square] = [] // The array sent to the UI at the end of iteration. Updating this should trigger a grid redraw
    @Published var gameState: GameState  = .ready
    @Published var iterationNumber: Int = 0 
    
    var isGameOver: Bool = false
    var gridSize: Int = 20
    
    func runGame() {
        guard isRunning else {
            return
        }
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.25) { // for a 10x10 grid, the loop needs to be slowed to see what's going on
            self.iterate()
            self.runGame()
        }
    }
    
    func readyArrayOfSquares() -> [Square] {
        var squares: [Square] = []
        
        for row in 0..<gridSize {
            for column in 0..<gridSize {
                squares.append(Square(xPosition: row, yPosition: column))
            }
        }
        return squares
    }
    
    func generateRandomSeed() {
        var seed: [Square] = []
        var aliveSquaresInSeed: [Square] = []
        
        resetGame()
        guard liveStartingSquares.isEmpty else {
            print("Live starting squares wasnt empty")
            return
        }
        
        for row in 0..<gridSize {
            for column in 0..<gridSize {
                seed.append(Square(xPosition: row, yPosition: column, isAlive: arc4random_uniform(2) == 0))
            }
        }
        
        aliveSquaresInSeed = seed.filter { $0.isAlive == true }
        
        for square in aliveSquaresInSeed {
            liveStartingSquares.append(square)
        }
        squareArray = seed
        isSeeded = true
    }
    
    func pauseGame() {
        guard isRunning else {
            return
        }
        isRunning = false
        gameState = .stopped
    }
    
    func resetGame() {
        liveStartingSquares = []
        squareArray = readyArrayOfSquares()
        gameState = .ready
        iterationNumber = 0
        isSeeded = false
    }
    
    //MARK: Iterate
    func iterate() {
        var bufferArrayOfSquares: [Square] = []
        var updatedArrayOfSquares: [Square] = []
        var livingSquaresAfterUpdate: [Square] = []
        var aliveNeighborsArray: [Square] = []
    

        bufferArrayOfSquares = squareArray // this squareArray is initialized with a blank Square array in GoLApp
        
        if iterationNumber == 0 {
            guard !liveStartingSquares.isEmpty else {
                print("Live Starting Squares not Found, resetting")
                resetGame()
                return
            }
            
            //Swap the chosen living squares into the "ready" array (all squares dead)
            for startingSquare in liveStartingSquares {
                if let index = bufferArrayOfSquares.firstIndex(where: {($0.xPosition == startingSquare.xPosition) && ($0.yPosition == startingSquare.yPosition)}) {
                    bufferArrayOfSquares[index] = Square(xPosition: startingSquare.xPosition, yPosition: startingSquare.yPosition, isAlive: true)
                }
            }
        }
        
        gameState = .iterating
        
        //check for neighbors
        for square in bufferArrayOfSquares {
            if iterationNumber == 0 {
                aliveNeighborsArray = liveStartingSquares.filter { $0.isNeighbor(to: square) }
            } else {
                let aliveFromLastIteration = squareArray.filter { $0.isAlive }
                aliveNeighborsArray = aliveFromLastIteration.filter { $0.isNeighbor(to: square) }
            }
            
            //Apply the game of life rules and build a new array of Squares to display
            switch (square.isAlive, aliveNeighborsArray.count) {
                // Any live cell with two or three live neighbors lives on to the next generation.
            case (true, 2), (true, 3):
                updatedArrayOfSquares.append(square)
                livingSquaresAfterUpdate.append(square)
                //Any dead cell with exactly 3 live neighbors becomes a live cell, as if by reproduction.
            case (false, 3):
                let newSquare = Square(xPosition: square.xPosition, yPosition: square.yPosition, isAlive: true)
                updatedArrayOfSquares.append(newSquare)
                livingSquaresAfterUpdate.append(newSquare)
                //All other live cells die in the next generation. All other dead cells stay dead.
            default:
                if square.isAlive {
                    let newSquare = Square(xPosition: square.xPosition, yPosition: square.yPosition, isAlive: false)
                    updatedArrayOfSquares.append(newSquare)
                } else {
                    updatedArrayOfSquares.append(square)
                }
            }
        }
        
        squareArray = updatedArrayOfSquares
        iterationNumber += 1
        
        isGameOver = livingSquaresAfterUpdate.count == 0
        if isGameOver, isRunning {
            isRunning.toggle()
        } else {
            gameState = .stopped
        }
    }
}

//MARK: GameState
enum GameState {
    case ready
    case iterating
    case stopped
}



