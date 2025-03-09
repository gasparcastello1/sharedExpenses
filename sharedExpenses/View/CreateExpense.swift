//
//  NewExpense.swift
//  sharedExpenses
//
//  Created by Gaspar Castello on 09/04/2024.
//

import SwiftUI
import SwiftData

struct CreateExpense: View {
    @Binding var isPresented: Bool
    @Query private var groups: [Group]

    @State var amount: String = ""
    @State var selectedUser: User
    @State var sharedType: SharingType = .equal
    @State var checkedPeople: [UserCheckTuple]
    var checkedPeopleList: [User] { checkedPeople.filter { $0.checked }.map { $0.user } }
    
    @State var percentagesList: [User: Percentage] = [:]
    
    enum SharingType: String, CaseIterable {
        case equal, custom
    }

    var group: Group
    var users: [User] { group.users }
    
    private func createSharedExpense() {
        var sharedWith: [ExpenseShare] = []
        
        if sharedType == .equal {
            // Distribute the amount equally among checked people
            let equalShare = 1.0 / Double(checkedPeopleList.count)
            for user in checkedPeopleList {
                let expenseShare = ExpenseShare(
                    user: user,
                    percentage: equalShare
                )
                sharedWith.append(expenseShare)
            }
        } else if sharedType == .custom {
            // Handle custom percentages, ensuring they sum up to 100
            let totalPercentage = percentagesList.values.reduce(0.0, +)
            guard totalPercentage == 1.0 else {
                // Handle validation error (total must be 100%)
                return
            }
            
            for user in checkedPeopleList {
                if let percentage = percentagesList[user] {
                    let expenseShare = ExpenseShare(
                        user: user,
                        percentage: percentage
                    )
                    sharedWith.append(expenseShare)
                }
            }
        }
        
        // Create the expense object
        let expense = Expense(
            amount: try! Double(amount, format: .number),
            paidBy: selectedUser,
            shares: sharedWith
        )
        
        // Add the expense to the group and save
        group.expenses.append(expense)
        isPresented = false
    }
    
    var body: some View {
        VStack {
            List {
                TextField("How much was it ?", text: $amount)
                
                Picker("Paid by", selection: $selectedUser) {
                    ForEach(users, id: \.self) { user in
                        Text(user.name)
                            .tag(user)
                    }
                }
                
                Section(header: Text("Split between")) {
                    
                    ForEach(checkedPeople.indices, id: \.self) { idx in
                        HStack {
                            Text(checkedPeople[idx].user.name)
                            Spacer()
                            UserCheckBox(isChecked: $checkedPeople[idx].checked)
                        }
                    }
                    HStack {
                        Spacer()
                        Button("All") {
                            let allSelected = checkedPeople.allSatisfy { $0.checked }
                            // Toggle the checked state of all users
                            for index in checkedPeople.indices {
                                checkedPeople[index].checked = !allSelected
                            }
                        }
                    }
                }
                
                Picker("shared as", selection: $sharedType) {
                    ForEach(SharingType.allCases, id: \.self) { type in
                        Text(type.rawValue.uppercased())
                    }
                }
                .pickerStyle(.segmented)
                
                if sharedType == .custom {
                    Section("Percentages") {
                        ForEach(checkedPeopleList, id: \.self) { user in
                            HStack {
                                Text(user.name)
                                Spacer()
                                TextField("Percentage", text: Binding(
                                    get: {
                                        String(percentagesList[user] ?? 0.0)
                                    }, set: { newValue in
                                        guard let doubleValue = Double(newValue) else {
                                            return
                                        }
                                        percentagesList[user] = doubleValue
                                    }))
                            }
                        }
                    }
                }
            }
            
            Spacer()
            
            if amount.isEmpty { Text("Enter amount").foregroundStyle(.primary) }
            Button(
                action: {
                    withAnimation {
                        createSharedExpense()
                }
            }) {
                Text("Save Expense")
                    .foregroundColor(.white)
                    .padding()
                    .background(.primary)
                    .cornerRadius(.infinity)
            }
            .disabled(amount.isEmpty)
        }
    }
}
