//
//  GroupDetail.swift
//  sharedExpenses
//
//  Created by Gaspar Castello on 08/04/2024.
//

import SwiftUI

struct GroupDetail: View {
    @State var group: Group
    
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
                    
                }
                Section(header: Text("Expenses")) {
                    ForEach(group.expenses, id: \.self) { expense in
                        Text("$\(String(expense.amount)), paid by: \(expense.paidBy.name) \nshared with:")
                    }
                }//DETAIL LIST
            }
            .toolbar {
                ToolbarItem {
                    Button("ADD AN EXPENSE", systemImage: "plus", action: {isPresentingSheet.toggle()})
                        .labelStyle(.titleAndIcon)
                        .sheet(isPresented: $isPresentingSheet) {
                            // Pass the binding to dismiss the sheet
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
//                    ToolbarItem(placement: .navigationBarTrailing) {
//                        EditButton()
//                    }
            }
    }
}
