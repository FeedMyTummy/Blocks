//
//  WBlockViewModel.swift
//  Blocks
//
//  Created by FeedMyTummy on 12/9/20.
//

import Foundation

final class WBlockViewModel {
    
    let block: WBlock
    var fractionFilled: Double { block.weight / WBlockViewModel.weightLimit }
    var sizeInMegabytes: Double { Double(block.sizeInBytes) / 1_000_000 }
    
    // MARK: Constants
    static let averageBlockInMinutes = 10
    private static let weightLimit = 4_000_000.0
    
    func formattedDate(from date: Date) -> String {
        switch block.time {
        case .past(let pastDate):
            let secondsSince = date.timeIntervalSince(pastDate).rounded()
            let minute = 60
            let minutesSince = Int(secondsSince) / minute
            
            if minutesSince < 1 {
                return "Less than 1 minute"
            } else {
                return "\(minutesSince) minute\(minutesSince > 1 ? "s" : "") ago"
            }
        case .upcoming(let nextBlockPosition):
            return "In ~ \(WBlockViewModel.averageBlockInMinutes * nextBlockPosition) minutes"
        }
    }
    
    init(block: WBlock) {
        self.block = block
    }
}
