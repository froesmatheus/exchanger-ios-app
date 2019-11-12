//
//  ExchangeRateRepository.swift
//  Exchanger
//
//  Created by Matheus Fróes on 20/10/19.
//  Copyright © 2019 Matheus Fróes. All rights reserved.
//

import Foundation

final class ExchangeRateRepository: ExchangeRateRepositoryProtocol {
    private let remoteSource: ExchangeRateService
    
    init(remoteSource: ExchangeRateService = ExchangeRateRemoteSource.init()) {
        self.remoteSource = remoteSource
    }
    
    func fetchExchangeRates(withBaseCurrency base: String, completion: @escaping (Result<[ExchangeRate], Error>) -> Void) {
        remoteSource.fetchExchangeRates(withBaseCurrency: base) { result in
            completion(result.map { $0.rates })
        }
    }
}
