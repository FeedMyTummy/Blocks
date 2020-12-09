//
//  WBlockView.swift
//  Blocks
//
//  Created by FeedMyTummy on 12/8/20.
//

import SwiftUI

struct WBlockView: View {
    
    private let block: WBlock
    private let waveHeight: CGFloat
    private let waveDuration: Double
    private let cornerRadius: CGFloat = 10
    
    var body: some View {
        VStack {
            BlockHeightText(height: block.height)
            ZStack {
                BlockView(block: block,
                          waveHeight: waveHeight,
                          waveDuration: waveDuration,
                          cornerRadius: cornerRadius)
            }
        }
        .padding(.vertical, 5)
        .multilineTextAlignment(.center)
    }
    
    init(block: WBlock, waveHeight: CGFloat, waveDuration: Double) {
        self.block = block
        self.waveHeight = waveHeight
        self.waveDuration = waveDuration
    }
}

struct BlockView_Previews: PreviewProvider {
    
    static var previews: some View {
        let blockViewWidth: CGFloat = 300
        let waveHeight: CGFloat = 0.02
        let waveDuration = 1.0
        
        let block = WBlock(height: Int.random(in: 10000...100000),
                           transactionCount: Int.random(in: 1000...3000),
                           averageFee: Int.random(in: 1...300),
                           feeRange: (min: 1, max: 100),
                           sizeMB: Double.random(in: 0...1.5),
                           weight: 2_000_000)
        
        return Group {
            WBlockView(block: block, waveHeight: waveHeight, waveDuration: waveDuration)
                .frame(width: blockViewWidth, height: blockViewWidth)
                .previewLayout(.sizeThatFits)
                .preferredColorScheme(.light)
            
            WBlockView(block: block, waveHeight: waveHeight, waveDuration: waveDuration)
                .frame(width: blockViewWidth, height: blockViewWidth)
                .previewLayout(.sizeThatFits)
                .preferredColorScheme(.dark)
        }
    }
}

fileprivate struct BlockHeightText: View {
    
    @Environment(\.colorScheme) private var colorScheme
    
    private let height: Int
    
    var body: some View {
            Text("# \(height)")
                .font(.largeTitle)
                .foregroundColor(colorScheme == .dark ? .white : .black)
    }
    
    init(height: Int) {
        self.height = height
    }
}

fileprivate struct BlockView: View {
    
    @State private var waveOffset = Angle.zero
    private let block: WBlock
    private let waveHeight: CGFloat
    private let waveDuration: Double
    private let cornerRadius: CGFloat
    
    @Environment(\.colorScheme) var colorScheme
    
    var body: some View {
        
        ZStack {
            RoundedRectangle(cornerRadius: cornerRadius)
                .stroke(colorScheme == .dark ? Color.gray : .black, lineWidth: 1)
                .overlay(
                    WWave(offset: waveOffset, fractionFilled: block.weight, height: waveHeight)
                        .fill(
                            Color(red: 0,
                                  green: 0.5,
                                  blue: 0.75,
                                  opacity: colorScheme == .dark ? 1 : 0.5)
                        )
                        .clipShape(
                            RoundedRectangle(cornerRadius: cornerRadius)
                                .scale(1)
                        )
                        .background(
                            (colorScheme == .dark ? Color.black : .white)
                                .clipShape(
                                    RoundedRectangle(cornerRadius: cornerRadius)
                                )
                        )
                )
                .aspectRatio(1, contentMode: .fit)
                .onAppear {
                    withAnimation(Animation.linear(duration: 2).repeatForever(autoreverses: false)) {
                        self.waveOffset = Angle(degrees: 360)
                    }
                }
            BlockTextView(block: block)
        }
    }
    
    init(block: WBlock, waveHeight: CGFloat, waveDuration: Double, cornerRadius: CGFloat) {
        self.block = block
        self.waveHeight = waveHeight
        self.waveDuration = waveDuration
        self.cornerRadius = cornerRadius
    }
}

fileprivate struct BlockTextView: View {
    
    @Environment(\.colorScheme) private var colorScheme
    private let block: WBlock
    
    var body: some View {
        VStack(spacing: 5) {
            Text("~\(block.averageFee) sat/vB")
            Text("\(block.feeRange.min) - \(block.feeRange.max) sat/vB")
            Text("\(block.size, specifier: "%.2f") MB")
                .padding(.top, 20)
                .font(Font.title.bold())
            Text("\(block.transactionCount) transaction\((block.transactionCount > 1 ? "s" : ""))")
                .padding(.top)
            Spacer()
        }
        .foregroundColor(colorScheme == .dark ? .white : .black)
        .padding(.top, 10)
    }
    
    init(block: WBlock) {
        self.block = block
    }
}
