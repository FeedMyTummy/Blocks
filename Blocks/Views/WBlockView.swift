//
//  WBlockView.swift
//  Blocks
//
//  Created by FeedMyTummy on 12/8/20.
//

import SwiftUI

struct WBlockView: View {
    
    private let blockViewModel: WBlockViewModel
    private let currentDate: Date
    
    // MARK: Constants
    private let configuration = BlockViewConfiguration(waveHeight: 0.02,
                                                       waveDuration: 1.0,
                                                       cornerRadius: 10)
    
    var body: some View {
        VStack {
            BlockHeightText(height: blockViewModel.block.height)
            ZStack {
                BlockBodyView(block: blockViewModel,
                          configuration: configuration)
                
                BlockTextView(blockViewModel: blockViewModel, currentDate: currentDate)
            }
        }
        .padding(.vertical, 5)
        .multilineTextAlignment(.center)
    }
    
    init(blockViewModel: WBlockViewModel, currentDate: Date) {
        self.blockViewModel = blockViewModel
        self.currentDate = currentDate
    }
}

fileprivate struct BlockHeightText: View {
    
    @Environment(\.colorScheme) private var colorScheme
    
    private let height: Int
    
    var body: some View {
            Text("# \(height)")
                .font(.largeTitle)
                .foregroundColor(colorScheme == .dark
                                    ? .white
                                    : .black)
    }
    
    init(height: Int) {
        self.height = height
    }
}

struct BlockViewConfiguration {
    let waveHeight: CGFloat
    let waveDuration: Double
    let cornerRadius: CGFloat
}

fileprivate struct BlockBodyView: View {
    
    @Environment(\.colorScheme) private var colorScheme
    @State private var waveOffset = Angle.zero
    @ObservedObject private var blockViewModel: WBlockViewModel
    
    private let configuration: BlockViewConfiguration
    
    var body: some View {
        ZStack {
            RoundedRectangle(cornerRadius: configuration.cornerRadius)
                .fill(colorScheme == .dark ? Color.black : .white)
            
            WWave(offset: waveOffset, fractionFilled: blockViewModel.fractionFilled, height: configuration.waveHeight)
                .fill(Color("block-wave-color"))
                .clipShape(RoundedRectangle(cornerRadius: configuration.cornerRadius))
                .onChange(of: blockViewModel.animate) { _ in runAnimation() }
                .onAppear { runAnimation() }
            
            RoundedRectangle(cornerRadius: configuration.cornerRadius)
                .stroke(colorScheme == .dark ? Color.gray : .black, lineWidth: 1)
        }
        .aspectRatio(1, contentMode: .fit)
    }
    
    func runAnimation() {
        withAnimation(
            blockViewModel.animate
                ? Animation.linear(duration: 2)
                           .repeatForever(autoreverses: false)
                : .linear(duration: 0))
        {
            waveOffset = Angle(degrees: blockViewModel.animate ? 360 : .zero)
        }
    }
    
    init(block: WBlockViewModel, configuration: BlockViewConfiguration) {
        self.blockViewModel = block
        self.configuration = configuration
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
                       currentDate: currentDate)
                
                .frame(width: blockViewWidth,
                       height: blockViewWidth)
                .previewLayout(.sizeThatFits)
                .preferredColorScheme(.light)
            
            WBlockView(blockViewModel: WBlockViewModel(block: block),
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
