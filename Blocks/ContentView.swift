//
//  ContentView.swift
//  Blocks
//
//  Created by FeedMyTummy on 12/7/20.
//

import SwiftUI

struct ContentView: View {
    
    private let blockViewWidth: CGFloat = 300
    
    private let block = WBlock(height: Int.random(in: 10000...100000),
                               transactionCount: Int.random(in: 1000...3000),
                               averageFee: Int.random(in: 1...300),
                               feeRange: (min: 1, max: Int.random(in: 1...100)),
                               sizeMB: Double.random(in: 0...1.5),
                               weight: Double.random(in: 0...4_000_000.0))
        
        var body: some View {
            WBlockView(block: block,
                       waveHeight: 0.025,
                       waveDuration: 2)
                .frame(width: blockViewWidth, height: blockViewWidth)
        }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
