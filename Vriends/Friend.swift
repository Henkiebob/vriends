//
//  Friend.swift
//  Friends
//
//  Created by Tjerk Dijkstra on 15/02/2018.
//  Copyright © 2018 Tjerk Dijkstra. All rights reserved.
//

import Foundation

struct Friend {
    
    // relationship health on a scale from 7 - 28 (28 is bad, 7 is healthy)
    var health = 28
    var name = ""
    var lastSeen = Date()
    var birthDate = Date()
    var relationship = ""
    
    
    //
    //    init() {
    //        let dateFormatter = DateFormatter()
    //        let date = Date()
    //        dateFormatter.dateFormat = "dd-MM-yyyy"
    //        self.lastSeen = dateFormatter.string(from: date)
    //    }
    
    // Find a way to check of the relationship is still healthy
    // Calculate difference between two dates
    // Return INT
    func checkRelationshipStatus() -> Int {
        
        //print(date)
        
        return 1
    }
    
    
}

