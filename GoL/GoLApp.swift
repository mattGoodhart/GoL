//
//  GoLApp.swift
//  GoL
//
//  Created by Matthew Goodhart on 7/20/23.
//

import SwiftUI

@main
struct GoLApp: App {
    var body: some Scene {
        WindowGroup {
            ContentView() {
                Model.shared.squareArray = Model.shared.readyArrayOfSquares() // immediately fill the model with a blank starting array
            }
        }
    }
}
