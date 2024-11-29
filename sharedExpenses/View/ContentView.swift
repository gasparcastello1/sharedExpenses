//
//  ContentView.swift
//  sharedExpenses
//
//  Created by Gaspar Castello on 08/04/2024.
//

import SwiftUI
import SwiftData

struct ContentView: View {
    @Environment(\.modelContext) private var modelContext
    @Query private var groups: [Group]
    @State private var isPresentingSheet = false
    
    var body: some View {
        NavigationView {
            List {
                Section(header: Text(groups.isEmpty ? "CREATE A GROUP" : "OPENED GROUPS")) {
                    ForEach(groups) { group in
                        NavigationLink(group.name) {
                            GroupDetail(group: group)
                        }
                    }
                    .onDelete(perform: deleteItems)
                }
            }//GROUPS LIST
            .listStyle(.plain)
            .toolbar {
                ToolbarItem(placement: .topBarLeading) {
                    Text("Groups")
                        .font(.headline)
                        .foregroundStyle(.red)
                }
                ToolbarItem(placement: .navigationBarTrailing) {
                    EditButton()
                }
                ToolbarItem {
                    Button("Sign In", systemImage: "plus", action: addItem)
                        .labelStyle(.titleAndIcon)
                        .sheet(isPresented: $isPresentingSheet) {
                            // Pass the binding to dismiss the sheet
                            NewGroupSheet(isPresented: $isPresentingSheet)
                        }
                }
                
            }
        }
    }
    
    private func addItem() {
        isPresentingSheet.toggle()
    }

    private func deleteItems(offsets: IndexSet) {
        withAnimation {
            for index in offsets {
                modelContext.delete(groups[index])
            }
        }
    }
}

#Preview {
    ContentView()
        .modelContainer(for: Group.self, inMemory: true)
}
