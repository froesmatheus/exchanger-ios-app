//
//  ExchangeRateRepository.swift
//  Exchanger
//
//  Created by Matheus Fróes on 20/10/19.
//  Copyright © 2019 Matheus Fróes. All rights reserved.
//

import Foundation

protocol ExchangeRateRepositoryProtocol: AnyObject {
    func fetchExchangeRates(withBaseCurrency base: String, completion: @escaping (Result<[ExchangeRate], Error>) -> Void)
}
