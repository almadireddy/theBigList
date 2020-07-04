//
//  SingleListView.swift
//  The Big List
//
//  Created by Aahlad Madireddy on 7/4/20.
//

import SwiftUI

struct SingleListView : View {
    var list: BigList
    @EnvironmentObject var allLists: AppState
    @State private var presentNewItemSheet: Bool = false
    
    private func deleteRow(at indexSet: IndexSet) {
        print("hey")
    }

    var body: some View {
        return ScrollView() {
            VStack(alignment: .leading, spacing: 15) {
                ForEach(allLists.getListItems(listId: list.id)!, id: \.id) { listItem in
                    Text(listItem.listText)
                        .font(.title2)
                        .multilineTextAlignment(.leading)
                        .frame(minWidth: 0,
                               idealWidth: .infinity,
                               maxWidth: .infinity,
                               minHeight: 60,
                               alignment: .leading)
                        .padding(.horizontal)
                        .background(Color("ThemeBg"))
                        .cornerRadius(15)
                        .contextMenu {
                            Button(action: {
                                print("deleteing \(listItem.listText)")
                                _ = self.allLists.deleteListItem(listItemId: listItem.id)
                                _ = self.allLists.refreshLists()
                            }) {
                                HStack {
                                    Text("Delete list item")
                                        .foregroundColor(Color.red)
                                    Image(systemName: "trash")
                                }
                            }
                        }
                }
                .onDelete(perform: self.deleteRow)
            }
            .frame(minWidth: 0, idealWidth: .infinity, maxWidth: .infinity, alignment: .leading)
            .padding(.horizontal)
        }
        .navigationBarTitle(list.listName)
        .toolbar(content: {
            Button(action: {
                self.presentNewItemSheet = true
            }) {
                Text("New item").font(.system(.body, design: .rounded))
            }
        })
        .sheet(isPresented: $presentNewItemSheet, content: {
            NewListItemForm(list: list).environmentObject(allLists)
        })
    }
}

struct NewListItemForm: View {
    var list: BigList
    @State private var newItemText: String = ""
    @EnvironmentObject var allLists: AppState
    @Environment(\.presentationMode) var presentationMode
    
    var body: some View {
        NavigationView() {
            ScrollView() {
                VStack(alignment: .leading) {
                    BigTextField(enteredText: $newItemText, placeholder: "New item" , onEditCommit: {
                        self.newItemText = newItemText.trimmingCharacters(in: .whitespaces)
                    })
                    .navigationBarTitle("New list item")
                    .navigationBarItems(trailing:
                        Button(action: {
                            _ = self.allLists.addNewListItem(listItemText: newItemText, parentListId: list.id)
                            _ = self.allLists.refreshLists()
                            self.newItemText = ""
                            self.presentationMode.wrappedValue.dismiss()
                        }) {
                            Text("Save item").font(.system(.body, design: .rounded))
                        }
                    )
                }
            }
        }
    }
}
