//
//  WBlock.swift
//  Blocks
//
//  Created by FeedMyTummy on 12/8/20.
//

import Foundation

struct WBlock {
    
    let height: Int
    let averageFee: Int
    let transactionCount: Int
    let feeRange: (min: Int, max: Int)
    let size: Double
    let weight: Double
    
    static let weightLimit = 4_000_000.0
    
    init(height: Int, transactionCount: Int, averageFee: Int, feeRange: (min: Int, max: Int), sizeMB: Double, weight: Double) {
        self.height = height
        self.transactionCount = transactionCount
        self.averageFee = averageFee
        self.feeRange = feeRange
        self.size = sizeMB
        self.weight = weight / WBlock.weightLimit
    }
    
}
