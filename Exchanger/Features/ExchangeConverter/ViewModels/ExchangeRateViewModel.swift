//
//  ExchangeRateViewModel.swift
//  Exchanger
//
//  Created by Matheus Fróes on 20/10/19.
//  Copyright © 2019 Matheus Fróes. All rights reserved.
//

import Foundation

final class ExchangeRateViewModel {
    private let repository: ExchangeRateRepositoryProtocol
    
    var startLoading: (() -> Void)?
    var endLoading: (() -> Void)?
    var showError: ((String) -> Void)?
    
    var changeBaseCurrency: ((String) -> Void)?
    var changeBaseAmount: ((String) -> Void)?
    var changeDestinationCurrency: ((String) -> Void)?
    var changeDestinationAmount: ((String) -> Void)?
    
    var getBaseAmount: (() -> String)?
    var getDestinationAmount: (() -> String)?
    
    init(repository: ExchangeRateRepositoryProtocol = ExchangeRateRepository.init()) {
        self.repository = repository
    }
    
    private var baseCurrency = "EUR" {
        didSet {
            changeBaseCurrency?(baseCurrency)
            
            let value = getDestinationAmount?() ?? ""
            didChangeDestinationAmount(value: value)
        }
    }
    
    private(set) var destinationRate: ExchangeRate? {
        didSet {
            if let rate = destinationRate {
                changeDestinationCurrency?(rate.currencySymbol)
                
                let value = getBaseAmount?() ?? ""
                didChangeBaseAmount(value: value)
            }
        }
    }
    
    private(set) var rates = [ExchangeRate]()
    
    func getExchangeRates(forCurrency currency: String? = nil) {
        let currency = currency ?? baseCurrency
        
        startLoading?()
        
        repository.fetchExchangeRates(withBaseCurrency: currency) { [weak self] result in
            guard let self = self else { return }
            
            switch result {
            case let .success(rates):
                self.rates = rates
                
                self.baseCurrency = currency
                self.destinationRate = rates.first { $0.currencySymbol == self.destinationRate?.currencySymbol } ?? rates.first
                
                self.endLoading?()
            case let .failure(error):
                self.showError?(error.localizedDescription)
            }
        }
    }
    
    func didChangeBaseCurrency(currency: ExchangeRate) {
        getExchangeRates(forCurrency: currency.currencySymbol)
    }
    
    func didChangeBaseAmount(value: String) {
        guard let destinationRate = destinationRate else { return }
    
        let numberValue = Exchanger.format(string: value)?.doubleValue ?? 0
        let conversion = numberValue * destinationRate.rate
        
        changeDestinationAmount?(format(number: conversion))
    }

    func didChangeDestinationAmount(value: String) {
        guard let destinationRate = destinationRate else { return }

        let numberValue = Exchanger.format(string: value)?.doubleValue ?? 0
        
        let conversion = numberValue / destinationRate.rate

        changeBaseAmount?(format(number: conversion))
    }
    
    func didChangeDestinationCurrency(currency: ExchangeRate) {
        self.destinationRate = currency
    }
}
