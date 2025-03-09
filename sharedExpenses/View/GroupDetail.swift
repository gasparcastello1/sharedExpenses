//
//  GroupDetail.swift
//  sharedExpenses
//
//  Created by Gaspar Castello on 08/04/2024.
//

import SwiftUI

struct GroupDetail: View {
    @State var group: Group
    @Environment(\.colorScheme) var colorScheme
    @State private var isBalanceSolved = false
    @State private var isPresentingSheet = false
    @State private var expenses = []
    @State private var copied = false
    
    @State private var formattedTransactions: String = ""
    private func getformattedTransactions() -> String {
        guard formattedTransactions.isEmpty else { return formattedTransactions }
        formattedTransactions = group.resolvedTransactions.map { transaction in
            "\(transaction.from.name) transfer $\(String(format: "%.2f", transaction.amount)) to \(transaction.to.name)"
        }.joined(separator: "\n")
        return formattedTransactions
    }
    private func getUsersBalance(_ id: UUID) -> Double? {
        let expenses = group.expenses
        let balances = DebtCalculator.computeNetBalances(expenses: expenses)
        if balances.keys.contains(id) {
            return balances[id]
        } else {
            return nil
        }
    }
    var body: some View {
        List {
            Section() {
                ForEach(group.users, id: \.self) { user in
                    HStack {
                        Text(user.name)
                        Spacer()
                        if let balance = getUsersBalance(user.id) {
                            Text(String(format: "%.2f", balance))
                                .foregroundStyle(balance < 0 ? Color.primary : Color.green)
                        }
                    }
                }
            }
            if !group.expenses.isEmpty {
                Section(header: simplifiedHeader) {
                    VStack {
                        if isBalanceSolved {
                            VStack {
                                ForEach(group.resolvedTransactions, content: { transaction in
                                    HStack {
                                        Spacer()
                                        Text("\(transaction.from.name) $\(String(format: "%.2f", transaction.amount)) ⇨ \(transaction.to.name)")
                                    }
                                })
                            }
                            
                        }
                        HStack {
                            Spacer()
                            Button("",systemImage: isBalanceSolved ? "chevron.up" : "chevron.down", action: {
                                isBalanceSolved.toggle()
                            })
                            .foregroundStyle(Color.primary)
                            Spacer()
                        }
                        .padding(.top)
                    }
                }
                
                Section(header: header ) {
                    ForEach(group.expenses, id: \.self) { expense in
                        Text("$\(String(expense.amount)), paid by: \(expense.paidBy.name) \nshared with: \(sharedUsersNames(from: expense.shares))")
                            .padding()
                    }
                    .onDelete { offsets in
                        withAnimation {
                            for index in offsets {
                                group.expenses.remove(at: index)
                            }
                        }
                    }
                }//DETAIL LIST
            }
        }
        .navigationTitle("\(group.name)")
        .toolbar {
            ToolbarItem(placement: .navigationBarTrailing) {
                Button(action: {
                    isPresentingSheet.toggle()
                }) {
                    HStack {
                        Image(systemName: "plus")
                    }
                }
                .labelStyle(.titleAndIcon)
                .sheet(isPresented: $isPresentingSheet) {
                    CreateExpense(
                        isPresented: $isPresentingSheet,
                        selectedUser: group.users[0],
                        checkedPeople: group.users.map({ user in
                            (user: user, checked: false)
                        }),
                        group: group
                    )
                }
            }
        }
    }
    
    private var simplifiedHeader: some View {
        HStack {
            Text("Simplified debts")
                Spacer()
                Button(
                    action: {
                    UIPasteboard.general.string = getformattedTransactions()
                        copied = true
                        DispatchQueue.main.asyncAfter(deadline: .now()+1.0, execute: {
                            copied = false
                        })
                }) {
                    Image(systemName: copied ? "checkmark" : "document.on.document")
                    .foregroundStyle(copied ? .green : .primary)
                }
        }
    }
    private var header: some View {
        HStack {
            Text( "Expenses" )
            Spacer()
            Button(action: {
                group.expenses.removeAll()
                formattedTransactions = ""
            }) {
                Image(systemName: "trash")
                    .foregroundStyle(.primary)
            }
        }
    }
    func sharedUsersNames(from shares: [ExpenseShare]) -> String {
        shares.compactMap { $0.user.name }.joined(separator: ", ")
    }
}
