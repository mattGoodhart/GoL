//
//  InfoView.swift
//  GoL
//
//  Created by Matthew Goodhart on 7/26/23.
//

import SwiftUI

struct InfoView: View {
    
    @Environment(\.dismiss) var dismiss
    
    var body: some View {
        
        ZStack {
            Rectangle()
                .foregroundColor(.gray)
                .background(.gray)
            
            VStack(alignment: .center, spacing: 40) {
                Text("Created by Matthew Goodhart")
                    .font(.title2)
                    .foregroundColor(.white)
                    .padding()
                Text("with Some Inspiration From:")
                    .font(.headline)
                    .foregroundColor(.white)
                    .padding()
                VStack(alignment: .leading) {
                    Text("'Game of Life in Swift Playgrounds' by Beau Nouvelle")
                        .foregroundColor(.white)
                    Text("https://getswifty.dev/game-of-life-in-swift-playgrounds/")
                    Spacer()
                    Text("'Creating Conway's Game of Life in Swift' by June Bash")
                        .foregroundColor(.white)
                    Text("https://www.junebash.com/blog/game-of-life/")
                    Spacer()
                    Button() {
                        dismiss()
                    } label: {
                        Text("Dismiss")
                        Image(systemName: "xmark.circle.fill")
                    }
                }
            }
            .padding(.vertical)
        }
    }
}

struct Modal_Previews: PreviewProvider {
    static var previews: some View {
        InfoView()
    }
}
