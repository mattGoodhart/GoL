//
//  Model.swift
//  GoL
//
//  Created by Matthew Goodhart on 7/21/23.
//

import SwiftUI

class Model: ObservableObject {
    
    static let shared = Model()
    
    var instructionalText: String {
        switch gameState {
        case .ready: return "Enter a Pattern or Generate Seed to Begin"
        default: return ""
        }
    }
    
    @Published var isRunning: Bool = false // Flag that indicates if game is autorunning
    @Published var liveStartingSquares: [Square] = [] //the squares chosen by the user before starting the game
    @Published var gridSize: Int = 10
    @Published var squareArray: [Square] = [] // The array sent to the UI at the end of iteration. Updating this should trigger a grid redraw
    @Published var gameState: GameState  = .ready //Updating this should update button states and text in UI
    @Published var iterationNumber: Int = 0 // Updating should increment the generation counter.
    
    func runGame() {
        
        guard isRunning else {
            return
        }
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.25) { // this makes pause laggy
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
        guard liveStartingSquares.isEmpty else {
            return
        }
        
        var seed: [Square] = []
        
        for row in 0..<gridSize {
            for column in 0..<gridSize {
                seed.append(Square(xPosition: row, yPosition: column, isAlive: arc4random_uniform(2) == 0))
            }
        }
        
        let aliveSquaresInSeed = seed.filter { $0.isAlive == true }
        for square in aliveSquaresInSeed {
            liveStartingSquares.append(square)
        }
        squareArray = seed
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
    }
    
    func iterate() {
        var bufferArrayOfSquares: [Square] = [] //the array of Squares to process
        var updatedArrayOfSquares: [Square] = [] //Squares after processing
        var livingSquaresAfterUpdate: [Square] = [] //only the living Squares after last iteration
        var aliveNeighborsArray: [Square] = []
    
        
        bufferArrayOfSquares = squareArray // this squareArray is initialized with a blank Square array in GoLApp
        
        if iterationNumber == 0 {
            guard !liveStartingSquares.isEmpty else {
                print("Live Starting Squares not Found, resetting")
                resetGame()
                return
            }
            //Swap the chosen living squares into the ready grid (all squares dead)
            for startingSquare in liveStartingSquares {
                if let index = bufferArrayOfSquares.firstIndex(where: {($0.xPosition == startingSquare.xPosition) && ($0.yPosition == startingSquare.yPosition)}) {
                    bufferArrayOfSquares[index] = Square(xPosition: startingSquare.xPosition, yPosition: startingSquare.yPosition, isAlive: true)
                }
            }
        }
        
        gameState = .iterating
        
        for square in bufferArrayOfSquares {
            if iterationNumber == 0 {
                //check for neighbors to the starting squares
                aliveNeighborsArray = liveStartingSquares.filter { $0.isNeighbor(to: square) }
            } else {
                //check for neighbors of last iteration
                let aliveFromLastIteration = squareArray.filter { $0.isAlive }
                aliveNeighborsArray = aliveFromLastIteration.filter { $0.isNeighbor(to: square) }
            }
            //Apply the rules and build a new Grid of Squares to display
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
        // DEBUG
        var positionsOfLivingSquaresAfterUpdate: [String] = []
        for square in livingSquaresAfterUpdate {
            positionsOfLivingSquaresAfterUpdate.append("(\(square.xPosition), \(square.yPosition))")
        }
        print(positionsOfLivingSquaresAfterUpdate)
        // End DEBUG
        
        squareArray = updatedArrayOfSquares
        
        iterationNumber += 1
        
        let isGameOver: Bool = livingSquaresAfterUpdate.count == 0
        if isGameOver, isRunning {
            isRunning.toggle()
        } else {
            gameState = .stopped
        }
    }
}

enum GameState {
    case ready
    case iterating
    case stopped
}



