//
//  ContentView.swift
//  Blocks
//
//  Created by FeedMyTummy on 12/7/20.
//

import SwiftUI

struct ContentView: View {
    
    @State private var currentDate = Date()
    @StateObject private var blockViewModel = WBlockViewModel(block: mockBlock())
    
    private let timer = Timer.publish(every: 60, on: .main, in: .common).autoconnect()
    private let blockViewWidth: CGFloat = 300
    
    var body: some View {
        VStack(spacing: 10) {
            Button("\(blockViewModel.animate ? "Stop" : "Start") animating") {
                blockViewModel.animate.toggle()
            }
            .padding(.bottom, 20)
            
            WBlockView(blockViewModel: blockViewModel,
                       currentDate: currentDate)
            
                .frame(width: blockViewWidth, height: blockViewWidth)
                .onReceive(timer) { _ in currentDate = Date() }
                .onReceive(NotificationCenter
                            .default
                            .publisher(for: UIApplication
                                        .willEnterForegroundNotification))
                { _ in
                    currentDate = Date()
                }
        }
    }
    
    private static func mockBlock() -> WBlock {
        let time: WBlock.BlockTime
        
        if Bool.random() {
            time = .past(Calendar.current.date(byAdding: .minute,
                                               value: 0,
                                               to: Date())!)
        } else {
            time = .upcoming(Int.random(in: 1...3))
        }
        
        return WBlock(height: Int.random(in: 100_000...500_000),
                      transactionCount: Int.random(in: 1000...3000),
                      averageFee: Int.random(in: 1...300),
                      feeRange: (min: 1, max: Int.random(in: 1...300)),
                      sizeInBytes: Int.random(in: 2_000_000...2_500_000),
                      weight: Double.random(in: 1_000_000...4_000_000.0),
                      time: time)
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
