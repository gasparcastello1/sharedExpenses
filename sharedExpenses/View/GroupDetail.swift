//
//  GroupDetail.swift
//  sharedExpenses
//
//  Created by Gaspar Castello on 08/04/2024.
//

import SwiftUI

struct GroupDetail: View {
    @State var group: Group
    
    @State private var isBalanceSolved = false
    @State private var isPresentingSheet = false
    @State private var expenses = []
    
    var body: some View {
        List {
            Section(header: Text("People")) {
                ForEach(group.users, id: \.self) { user in
                    Text(user.name)
                }
                .onDelete { offsets in
                    withAnimation {
                        for index in offsets {
                            group.users.remove(at: index)
                        }
                    }
                }
            }
            
            Section(header: Text("Simplified debts")) {
                VStack {
                    HStack {
                        Spacer()
                        Button("Resume transactions") {
                            isBalanceSolved.toggle()
                        }
                    }
                    if isBalanceSolved {
                        VStack {
                            ForEach(group.resolvedTransactions, content: { transaction in
                                HStack {
                                    Spacer()
                                    Text("\(transaction.from.name) transfer $\(String(format: "%.2f", transaction.amount)) to \(transaction.to.name)")
                                }
                            })
                            
                        }
                        
                    }
                }
            }
            
            Section(header: Text("Expenses")) {
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
        .navigationTitle("\(group.name)")
        .toolbar {
            ToolbarItem(placement: .navigationBarTrailing) {
                Button(action: {
                    isPresentingSheet.toggle()
                }) {
                    HStack {
                        Image(systemName: "plus")
                        Text("Add")
                    }
                }
                .labelStyle(.titleAndIcon)
                .sheet(isPresented: $isPresentingSheet) {
                    NewExpense(
                        isPresented: $isPresentingSheet,
                        selectedUser: group.users[0],
                        checkedPeople: group.users.map({ user in
                            (user: user, checked: false)
                        }),
                        id: group.id
                    )
                }
            }
        }
    }
    
    func sharedUsersNames(from shares: [ExpenseShare]) -> String {
        shares.compactMap { $0.user.name }.joined(separator: ", ")
    }
}
