//
//  RuntimeError.swift
//  Exchanger
//
//  Created by Matheus Fróes on 21/10/19.
//  Copyright © 2019 Matheus Fróes. All rights reserved.
//

import Foundation

struct RuntimeError: LocalizedError {
    let message: String

    init(_ message: String) {
        self.message = message
    }

    var errorDescription: String? {
        return message
    }
}
