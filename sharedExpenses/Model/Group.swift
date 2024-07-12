//
//  Group.swift
//  sharedExpenses
//
//  Created by Gaspar Castello on 08/04/2024.
//

import Foundation
import SwiftData

@Model
final class Group: Codable {
    let id =  UUID().uuidString
    var name: String
    var users: [User]?
    var expenses: [Expense]? = []
    
    init(name: String, users: [User]) {
        self.name = name
        self.users = users
    }
    
    enum CodingKeys: String, CodingKey {
        case name
        case users
        case expenses
    }
    
    required init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        self.name = try container.decode(String.self, forKey: .name)
        self.users = try container.decode([User].self, forKey: .users)
        self.expenses = try container.decode([Expense].self, forKey: .expenses)
    }
    func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encode(name, forKey: .name)
        try container.encode(users, forKey: .users)
        try container.encode(expenses, forKey: .expenses)
    }
}
