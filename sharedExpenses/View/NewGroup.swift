//
//  NewGroup.swift
//  sharedExpenses
//
//  Created by Gaspar Castello on 08/04/2024.
//

import SwiftUI

struct NewGroupSheet: View {
    @Environment(\.modelContext) private var modelContext
    @Binding var isPresented: Bool
    @State private var name: String = "Shoes and mates"
    @State private var checkedPeople: [UserCheckTuple] = [
        (user: User(name:"Gaspi"), checked: false),
        (user: User(name:"Ana"), checked: false),
        (user: User(name:"Max"), checked: false),
        (user: User(name:"Meli"), checked: false),
        (user: User(name:"Martin"), checked: false),
        (user: User(name:"Jazmin"), checked: false),
        (user: User(name:"Flaca"), checked: false)
    ]
    
    private var checkedUsers: [User] { checkedPeople
        .filter { $0.checked }
        .map { $0.user }
    }
    
    var body: some View {
        VStack {
            TextField("Name", text: $name)
                .padding()
            List {
                ForEach(checkedPeople.indices, id: \.self) { index in
                    HStack {
                        Text(checkedPeople[index].user.name)
                        Spacer()
                        UserCheckBox(isChecked: $checkedPeople[index].checked)
                    }
                }
            }
            .listStyle(.plain)
            
            .padding()

            Button("SAVE") {
                withAnimation {
                    let newItem = Group(name: name, users: checkedUsers)
                    modelContext.insert(newItem)
                    isPresented = false
                }
            }
            
        }//: VSTACK
        .padding()
        .cornerRadius(10)
    }
}

struct UserCheckBox: View {
    @Binding var isChecked: Bool

    var body: some View {
        Button(action: {
            isChecked.toggle()
        }) {
            Image(systemName: isChecked ? "checkmark.square" : "square")
                .resizable()
                .frame(width: 20, height: 20)
                .foregroundColor(isChecked ? .red : .gray)
        }
    }
}
