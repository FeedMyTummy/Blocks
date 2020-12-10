//
//  WBlockView.swift
//  Blocks
//
//  Created by FeedMyTummy on 12/8/20.
//

import SwiftUI

struct WBlockView: View {
    
    private let blockViewModel: WBlockViewModel
    private let waveHeight: CGFloat
    private let waveDuration: Double
    private let cornerRadius: CGFloat = 10
    private let currentDate: Date
    
    var body: some View {
        VStack {
            BlockHeightText(height: blockViewModel.block.height)
            ZStack {
                BlockView(block: blockViewModel,
                          waveHeight: waveHeight,
                          waveDuration: waveDuration,
                          cornerRadius: cornerRadius)
                
                BlockTextView(blockViewModel: blockViewModel, currentDate: currentDate)
            }
        }
        .padding(.vertical, 5)
        .multilineTextAlignment(.center)
    }
    
    init(blockViewModel: WBlockViewModel, waveHeight: CGFloat, waveDuration: Double, currentDate: Date) {
        self.blockViewModel = blockViewModel
        self.waveHeight = waveHeight
        self.waveDuration = waveDuration
        self.currentDate = currentDate
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
    private let blockViewModel: WBlockViewModel
    private let waveHeight: CGFloat
    private let waveDuration: Double
    private let cornerRadius: CGFloat
    
    @Environment(\.colorScheme) private var colorScheme
    
    var body: some View {
        ZStack {
            RoundedRectangle(cornerRadius: cornerRadius)
                .fill(colorScheme == .dark ? Color.black : .white)
            
            WWave(offset: waveOffset, fractionFilled: blockViewModel.fractionFilled, height: waveHeight)
                .fill(
                    Color(red: 0,
                          green: 0.5,
                          blue: 0.75,
                          opacity: colorScheme == .dark ? 1 : 0.5)
                ).clipShape(
                    RoundedRectangle(cornerRadius: cornerRadius)
                )
                .onAppear {
                    withAnimation(
                        Animation.linear(duration: 2)
                                    .repeatForever(autoreverses: false)
                    ) {
                        self.waveOffset = Angle(degrees: 360)
                    }
                }
            
            RoundedRectangle(cornerRadius: cornerRadius)
                .stroke(colorScheme == .dark ? Color.gray : .black, lineWidth: 1)
        }
        .aspectRatio(1, contentMode: .fit)
    }
    
    init(block: WBlockViewModel, waveHeight: CGFloat, waveDuration: Double, cornerRadius: CGFloat) {
        self.blockViewModel = block
        self.waveHeight = waveHeight
        self.waveDuration = waveDuration
        self.cornerRadius = cornerRadius
    }
}

fileprivate struct BlockTextView: View {
    
    @Environment(\.colorScheme) private var colorScheme
    
    private let blockViewModel: WBlockViewModel
    private let currentDate: Date
    
    var body: some View {
        VStack(spacing: 5) {
            Text("~\(blockViewModel.block.averageFee) sat/vB")
            Text("\(blockViewModel.block.feeRange.min) - \(blockViewModel.block.feeRange.max) sat/vB")
            Text("\(blockViewModel.sizeInMegabytes, specifier: "%.2f") MB")
                .padding(.top, 20)
                .font(Font.title.bold())
            Text("\(blockViewModel.block.transactionCount) transaction\((blockViewModel.block.transactionCount > 1 ? "s" : ""))")
                .padding(.top)
            Text("\(blockViewModel.formattedDate(from: currentDate))")
                .padding(.top)
            Spacer()
        }
        .foregroundColor(colorScheme == .dark ? .white : .black)
        .padding(.top, 10)
    }
    
    init(blockViewModel: WBlockViewModel, currentDate: Date) {
        self.blockViewModel = blockViewModel
        self.currentDate = currentDate
    }
}

struct BlockView_Previews: PreviewProvider {
    
    @State private static var currentDate = Date()
    private static let timer = Timer.publish(every: 1, on: .main, in: .common).autoconnect()
    
    static var previews: some View {
        let blockViewWidth: CGFloat = 300
        let waveHeight: CGFloat = 0.02
        let waveDuration = 1.0
        
        let time: WBlock.BlockTime
        
        if Bool.random() {
             time = .past(Calendar.current.date(byAdding: .minute,
                                                value: -1,
                                                to: Date())!)
        } else {
            time = .upcoming(Int.random(in: 1...3))
        }
        
        let block = WBlock(height: Int.random(in: 100_000...500_000),
                           transactionCount: Int.random(in: 1000...3000),
                           averageFee: Int.random(in: 1...300),
                           feeRange: (min: 1, max: 100),
                           sizeInBytes: Int.random(in: 2_000_000...2_500_000),
                           weight: Double.random(in: 1_000_000...4_000_000.0),
                           time: time)
        
        return Group {
            WBlockView(blockViewModel: WBlockViewModel(block: block),
                       waveHeight: waveHeight,
                       waveDuration: waveDuration,
                       currentDate: currentDate)
                
                .frame(width: blockViewWidth,
                       height: blockViewWidth)
                .previewLayout(.sizeThatFits)
                .preferredColorScheme(.light)
            
            WBlockView(blockViewModel: WBlockViewModel(block: block),
                       waveHeight: waveHeight,
                       waveDuration: waveDuration,
                       currentDate: currentDate)
                .frame(width: blockViewWidth,
                       height: blockViewWidth)
                .previewLayout(.sizeThatFits)
                .preferredColorScheme(.dark)
        }
        .onReceive(timer) { value in
            let timeIntervalSince = value.timeIntervalSince(currentDate)
            
            if Int(timeIntervalSince).isMultiple(of: 60) {
                currentDate.addTimeInterval(timeIntervalSince)
            }
        }
    }
}
