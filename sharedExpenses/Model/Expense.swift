//
//  Expense.swift
//  sharedExpenses
//
//  Created by Gaspar Castello on 10/04/2024.
//

import Foundation
import SwiftData

@Model
class Expense: Codable {
    let amount: Double
    let paidBy: User?
    let sharedWith: [User: Percentage]
    
    enum CodingKeys: String, CodingKey {
        case id
        case amount
        case paidBy
        case sharedWith
    }
    
    required init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        self.amount = try container.decode(Double.self, forKey: .amount)
        self.paidBy = try container.decode(User.self, forKey: .paidBy)
        self.sharedWith = try container.decode([User: Percentage].self, forKey: .sharedWith)
    }
    
    init(amount: Double, paidBy: User, sharedWith: [User: Percentage]) {
        self.amount = amount
        self.paidBy = paidBy
        self.sharedWith = sharedWith
    }
    func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encode(amount, forKey: .amount)
        try container.encode(paidBy, forKey: .paidBy)
        try container.encode(sharedWith, forKey: .sharedWith)
    }
}

