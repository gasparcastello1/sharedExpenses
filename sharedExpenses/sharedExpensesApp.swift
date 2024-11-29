//
//  SharedExpensesApp.swift
//  SharedExpenses
//
//  Created by Gaspar Castello on 08/04/2024.
//

import SwiftUI
import SwiftData

@main
struct SharedExpensesApp: App {
    var sharedModelContainer: ModelContainer = {
        let schema: Schema = .init(
            [
                Group.self,
                Expense.self,
                ExpenseShare.self,
                User.self
            ],
            version: SchemaV2.versionIdentifier
        )
        let modelConfiguration: ModelConfiguration = .init(
            schema: schema,
            isStoredInMemoryOnly: false
        )

        do {
            return try ModelContainer(
                for: schema,
                migrationPlan: UsersMigrationPlan.self,
                configurations: [modelConfiguration]
            )
        } catch {
            fatalError("Could not create ModelContainer: \(error)")
        }
    }()

    var body: some Scene {
        WindowGroup {
            ContentView()
        }
        .modelContainer(sharedModelContainer)
    }
}
