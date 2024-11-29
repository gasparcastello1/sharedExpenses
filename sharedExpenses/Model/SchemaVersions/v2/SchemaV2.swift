//
//  SchemaV2.swift
//  sharedExpenses
//
//  Created by Gaspar Castello on 28/11/2024.
//
import Foundation
import SwiftData

enum SchemaV2: VersionedSchema {
    static var versionIdentifier = Schema.Version(2, 0, 0)
    
    static var models: [any PersistentModel.Type] {
        [
            Group.self,
            Expense.self,
            ExpenseShare.self,
            User.self
        ]
    }
    
    @Model
    class Expense {
        var id: UUID = UUID()
        var amount: Double
        var paidBy: User
        var shares: [ExpenseShare] = []
        
        init(amount: Double, paidBy: User, shares: [ExpenseShare]) {
            self.amount = amount
            self.paidBy = paidBy
            self.shares = shares
        }
    }
    
    @Model
    class ExpenseShare {
        var user: User
        var percentage: Double // Represent the share as a percentage (0.0 to 1.0)
        
        init(user: User, percentage: Double) {
            self.user = user
            self.percentage = percentage
        }
    }
    
    @Model
    class Group {
        @Attribute(.unique) var id: UUID = UUID()
        var name: String
        var users: [User]
        var expenses: [SchemaV2.Expense] = []
        
        init(name: String, users: [User]) {
            self.name = name
            self.users = users
            users.forEach { user in
                if !user.groups.contains(self) {
                    user.groups.append(self)
                }
            }
        }
        
        //MARK: Computed properties
        @Transient
        var computedTransactions: [DebtCalculator.Transaction] {
            DebtCalculator.simplifyDebts(expenses: expenses)
        }
        @Transient
        var resolvedTransactions: [DebtCalculator.ResolvedTransaction] {
            DebtCalculator.resolveTransactionsToUsers(expenses: expenses, users: users)
        }
    }

    @Model
    class User {
        @Attribute(.unique) var id: UUID = UUID()
        var name: String
        var groups: [Group] = []
        
        init(name: String) {
            self.name = name
        }
    }
}
