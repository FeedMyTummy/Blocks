//
//  WBlock.swift
//  Blocks
//
//  Created by FeedMyTummy on 12/8/20.
//

import Foundation

struct WBlock {
    
    enum BlockTime {
        case past(Date)
        case upcoming(Int)
    }
    
    let height: Int
    let averageFee: Int
    let transactionCount: Int
    let feeRange: (min: Int, max: Int)
    let sizeInBytes: Int
    let weight: Double
    let time: BlockTime
    
    init(height: Int, transactionCount: Int, averageFee: Int, feeRange: (min: Int, max: Int), sizeInBytes: Int, weight: Double, time: BlockTime) {
        self.height = height
        self.transactionCount = transactionCount
        self.averageFee = averageFee
        self.feeRange = feeRange
        self.sizeInBytes = sizeInBytes
        self.weight = weight
        self.time = time
    }
    
}
