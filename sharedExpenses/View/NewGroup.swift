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
    @State private var name: String = ""
    @State private var checkedPeople: [UserCheckTuple] = [
        (user: User(name:"Gaspi"), checked: false),
        (user: User(name:"Fau"), checked: false),
        (user: User(name:"Mica"), checked: false),
        (user: User(name:"Lean"), checked: false),
        (user: User(name:"Vero"), checked: false),
        (user: User(name:"Juampi"), checked: false),
        (user: User(name:"Gime"), checked: false),
        (user: User(name:"Bian"), checked: false),
        (user: User(name:"Lau"), checked: false),
        (user: User(name:"Brisa"), checked: false),
        (user: User(name:"Tincho"), checked: false),
        (user: User(name:"Aili"), checked: false)
    ]
    
    private var checkedUsers: [User] { checkedPeople
        .filter { $0.checked }
        .map { $0.user }
    }
    
    var body: some View {
        VStack {
            TextField("Ex: Birthday party", text: $name)
                .padding()
            TextField("John William", text: $name)
                .padding()
            
//            List {
//                ForEach(checkedPeople.indices, id: \.self) { index in
//                    HStack {
//                        Text(checkedPeople[index].user.name)
//                        Spacer()
//                        UserCheckBox(isChecked: $checkedPeople[index].checked)
//                    }
//                }
//            }
//            .listStyle(.plain)
            
            .padding()
            Button(
                action: {
                    withAnimation {
                        //TODO: Create Users
                        let newItem = Group(name: name, users: checkedUsers)
                        modelContext.insert(newItem)
                        isPresented = false
                    }
                }
            ) {
                Text("SAVE")
                    .foregroundColor(.white)
                    .padding()
                    .background(.red)
                    .cornerRadius(.infinity)
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
