//
//  User.swift
//  sharedExpenses
//
//  Created by Gaspar Castello on 10/04/2024.
//

import Foundation
import SwiftData

@Model
class User: Codable {
    let name: String
    let id =  UUID().uuidString
    var groups: [Group]? = []
    
    init(name: String) {
        self.name = name
    }
    
    //MARK: Codable
    enum CodingKeys: String, CodingKey {
        case name
        case id
        case groups
    }
    
    required init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        self.name = try container.decode(String.self, forKey: .name)
        self.id = try container.decode(String.self, forKey: .id)
        self.groups = try container.decode([Group].self, forKey: .groups)
    }
    
    func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encode(name, forKey: .name)
        try container.encode(id, forKey: .id)
        try container.encode(groups, forKey: .groups)
    }
}

extension User: Hashable {
    
    public static func == (lhs: User, rhs: User) -> Bool {
        lhs.id == rhs.id
    }
    
    public func hash(into hasher: inout Hasher) {
        hasher.combine(id)
    }
}
