//
//  Commons.swift
//  sharedExpenses
//
//  Created by Gaspar Castello on 10/04/2024.
//

import Foundation

struct Icon {
    static let ok = "🤙🏽"
    static let checked = "✅"
    static let badBalance = "🤯"
}

typealias Percentage = Double
typealias Amount = Double
typealias Debt = [User: Amount]
typealias UserCheckTuple = (user: User, checked: Bool)
