//
//  ExchangeRateResult.swift
//  Exchanger
//
//  Created by Matheus Fróes on 21/10/19.
//  Copyright © 2019 Matheus Fróes. All rights reserved.
//

import Foundation

struct ExchangeRateResult: Decodable {
    let rates: [ExchangeRate]
    
    enum CodingKeys: String, CodingKey {
        case rates
    }
    
    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        
        let ratesMap = try container.decode([String: Double].self, forKey: .rates)
        
        rates = ratesMap.map { ExchangeRate(currencySymbol: $0.key, rate: $0.value) }
    }
}
