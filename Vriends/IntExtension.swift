//
//  IntExtension.swift
//  Vriends
//
//  Created by Geart Otten on 15/06/2018.
//  Copyright © 2018 Tjerk Dijkstra. All rights reserved.
//

import Foundation

extension Int {
    static func random(range: CountableClosedRange<Int>) -> Int {
        let MAX_RANDOM_VALUE: UInt32 = UInt32(range.upperBound)
        let MIN_RANDOM_VALUE: UInt32 = UInt32(range.lowerBound)
        
        return Int(arc4random_uniform(MAX_RANDOM_VALUE - MIN_RANDOM_VALUE) + MIN_RANDOM_VALUE)
    }
}
