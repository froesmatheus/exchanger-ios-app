//
//  Extensions.swift
//  Exchanger
//
//  Created by Matheus Fróes on 21/10/19.
//  Copyright © 2019 Matheus Fróes. All rights reserved.
//

import Foundation

func format(number: Double) -> String {
    let formatter = NumberFormatter()
    formatter.minimumIntegerDigits = 1
    formatter.maximumFractionDigits = 2
    formatter.minimumFractionDigits = 2
    return formatter.string(from: number as NSNumber) ?? ""
}

func format(string: String) -> NSNumber? {
    let formatter = NumberFormatter()
    formatter.minimumIntegerDigits = 1
    formatter.maximumFractionDigits = 2
    formatter.minimumFractionDigits = 2
    return formatter.number(from: string)
}
