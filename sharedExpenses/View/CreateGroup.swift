//
//  NewGroup.swift
//  sharedExpenses
//
//  Created by Gaspar Castello on 08/04/2024.
//

import SwiftUI

struct CreateGroupSheet: View {
    @Environment(\.modelContext) private var modelContext
    @Binding var isPresented: Bool
    @State private var groupName: String = ""
    @State private var personName: String = ""
    @State private var checkIn: [String] = []
    
    var body: some View {
        VStack {
            TextField("Ex: Birthday party", text: $groupName)
                .padding()
            List {
                ForEach(checkIn.indices, id: \.self) { index in
                    HStack {
                        Image(systemName: "trash")
                            .tint(.primary)
                        Text(checkIn[index])
                        Spacer()
                    }
                    .onTapGesture {
                        checkIn.remove(at: index)
                    }
                }

                HStack {
                    Button(action: {
                        withAnimation {
                            if !personName.isEmpty {
                                checkIn.append(personName)
                                personName = ""
                            }
                        }
                    }) {
                        Image(systemName: "person.badge.plus")
                            .tint(.primary)
                    }
                    TextField("Ex: Juan Carlo", text: $personName)
                    
                }//: HSTACK
            }
            .listStyle(.plain)
            .listRowSeparator(.hidden)
            Button( action: createGroup) {
                Text("CREATE")
                    .foregroundColor(.white)
                    .fontWeight(.bold)
                    .padding()
                    .background(.primary)
                    .cornerRadius(.infinity)
            }
        }
        .padding()
    }
    
    private func mapNames() -> [User] {
        checkIn.map { User(name: $0) }
    }
    
    private func createGroup() {
        let users = mapNames()
        let newGroup = Group(
            name: groupName,
            users: users
        )
        modelContext.insert(newGroup)
        isPresented = false
    }
}
