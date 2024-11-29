//
//  UsersMigrationPlan.swift
//  sharedExpenses
//
//  Created by Gaspar Castello on 28/11/2024.
//
import SwiftData
//MARK: - Plans
enum UsersMigrationPlan: SchemaMigrationPlan {
    
    static var stages: [MigrationStage] {
        [migrateV1toV2]
    }
    static let migrateV1toV2 = MigrationStage.custom(
        fromVersion: SchemaV1.self,
        toVersion: SchemaV2.self,
        willMigrate: { context in
            print("context:", context)
        }, didMigrate: nil
    )
    static var schemas: [any VersionedSchema.Type] {
        [SchemaV1.self, SchemaV2.self]
    }
}
//MARK: - Typealiases
typealias User = SchemaV2.User
typealias Group = SchemaV2.Group
typealias Expense = SchemaV2.Expense
typealias ExpenseShare = SchemaV2.ExpenseShare
