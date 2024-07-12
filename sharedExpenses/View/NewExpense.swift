//
//  NewExpense.swift
//  sharedExpenses
//
//  Created by Gaspar Castello on 09/04/2024.
//

import SwiftUI
import SwiftData

struct NewExpense: View {
    @Binding var isPresented: Bool
    @Query private var groups: [Group]
    
    @State var amount: String = ""
    @State var selectedUser: User
    @State var sharedType: SharingType = .equal
    @State var checkedPeople: [UserCheckTuple]
    var checkedPeopleList: [User] {
        checkedPeople.filter { $0.checked }.map { $0.user }
    }
    
    @State var percentagesList: [User: Percentage] = [:]
    
    enum SharingType: String, CaseIterable {
        case equal, custom
    }
    
    var id: PersistentIdentifier
    var group: Group! {
        groups.first { group in
            group.id == id
        }
    }
    var users: [User] { group.users }
    
    var body: some View {
        VStack {
            List {
                TextField("$", text: $amount)
                
                Picker("Paid by", selection: $selectedUser) {
                    ForEach(users) { user in
                        Text(user.name)
                        //                            .tag(user)
                    }
                }
                Section("Split between") {
                    ForEach(checkedPeople.indices, id: \.self) { idx in
                        HStack {
                            Text(checkedPeople[idx].user.name)
                            Spacer()
                            UserCheckBox(isChecked: $checkedPeople[idx].checked)
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
                        //validates total percentage must sum 100, enter only number up to 2 digits
                    }
                }
            }
            
            Spacer()
            
            Button(action: {
                withAnimation {
                    var sharedWith: [User: Percentage]
                    if sharedType == .equal {
                        //
                    }
                    let expense = Expense(
                        amount: try! Double(amount, format: .number),
                        paidBy: selectedUser,
                        sharedWith: [:]
                    )
                    // error:
//                    Thread 1: "Illegal attempt to establish a relationship 'paidBy' between objects in different contexts (source = <NSManagedObject: 0x600002220370> (entity: Expense; id: 0x6000003124c0 <x-coredata:///Expense/t4E878B2D-9604-4567-86E3-69DBD146CB567>; data: {\n    amount = 3154;\n    paidBy = nil;\n    sharedWith = nil;\n}) , destination = <NSManagedObject: 0x600002157cf0> (entity: User; id: 0x8ead11dcd33080ee <x-coredata://FFB65CDB-199B-47E3-9FA5-C81075AD429E/User/p4>; data: {\n    groups = \"<relationship fault: 0x600000313280 'groups'>\";\n    id = \"267A6D5B-013C-4D16-B0D8-FFD0A631DA51\";\n    name = Gaspi;\n}))"
                    group.modelContext
                    group.expenses.append(expense)
                    isPresented = false
                }
            }) {
                Text("Save Expense")
                    .foregroundColor(.white)
                    .padding()
                    .background(.red)
                    .cornerRadius(.infinity)
            }
        }
//        .toolbar {
//            ToolbarItem(placement: .principal) {
//                Text("New Expense")
//            }
//            ToolbarItem(placement: .topBarLeading) {
//                Button(action: {isPresented.toggle()}) {
//                    Text("Cancel")
//                }
//                .foregroundStyle(.red)
//            }
//        }
    }
}
