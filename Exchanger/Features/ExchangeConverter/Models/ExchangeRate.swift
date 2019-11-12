//
//  ExchangeRate.swift
//  Exchanger
//
//  Created by Matheus Fróes on 21/10/19.
//  Copyright © 2019 Matheus Fróes. All rights reserved.
//

import Foundation

struct ExchangeRate: Equatable {
    let currencySymbol: String
    let rate: Double
    
    init(currencySymbol: String, rate: Double = 0) {
        self.currencySymbol = currencySymbol
        self.rate = rate
    }
    
    static func == (lhs: ExchangeRate, rhs: ExchangeRate) -> Bool {
        return lhs.currencySymbol == rhs.currencySymbol
    }
}
