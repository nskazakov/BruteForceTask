//
//  BruteForceOperation.swift
//  Pr2503
//
//  Created by Denis Aganov on 21.12.2021.
//

import UIKit

class BruteForceOperation: Operation {
    var bruteForce: BruteForce
    var password = ""
    
    init(_ bruteForce: BruteForce) {
        self.bruteForce = bruteForce
    }
    
    override func main() {
        if isCancelled {
            return
        }
        
        password = bruteForce.bruteForce(passwordToUnlock: bruteForce.password)
    }
}
