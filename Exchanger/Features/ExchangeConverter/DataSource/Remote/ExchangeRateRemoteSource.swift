//
//  ExchangeRateSource.swift
//  Exchanger
//
//  Created by Matheus Fróes on 20/10/19.
//  Copyright © 2019 Matheus Fróes. All rights reserved.
//

import Foundation

final class ExchangeRateRemoteSource: ExchangeRateService {
    private let session: URLSession

    private var baseURL: URL {
        return URL(string: "https://api.exchangeratesapi.io/")!
    }

    init(session: URLSession = .shared) {
        self.session = session
    }
    
    func fetchExchangeRates(withBaseCurrency base: String, completion: @escaping (Result<ExchangeRateResult, Error>) -> Void) {
        let url = baseURL.appendingPathComponent("latest")
        
        var components = URLComponents(url: url, resolvingAgainstBaseURL: false)
        components?.queryItems = [
            URLQueryItem(name: "base", value: base)
        ]
        
        makeRequest(with: components!.url!, response: ExchangeRateResult.self, completion: completion)
    }
    
    private func makeRequest<Response: Decodable>(with url: URL, response _: Response.Type, completion: @escaping (Result<Response, Error>) -> Void) {
        session.dataTask(with: url) { data, _, error in
            if let error = error {
                dispatch { completion(.failure(error)) }
                return
            }

            guard let data = data else {
                dispatch { completion(.failure(RuntimeError("Unable to make request"))) }
                return
            }

            if let modelResponse = parseJSON(from: data, to: Response.self) {
                dispatch { completion(.success(modelResponse)) }
            } else {
                dispatch { completion(.failure(RuntimeError("There was an error while mapping the network response"))) }
            }
        }.resume()

        func dispatch(block: @escaping () -> Void) {
            DispatchQueue.main.async(execute: block)
        }
    }
}

private func parseJSON<Model: Decodable>(from data: Data, to _: Model.Type) -> Model? {
    do {
        return try JSONDecoder().decode(Model.self, from: data)
    } catch {
        print(error)
    }
    
    return nil
}
