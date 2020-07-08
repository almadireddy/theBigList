//
//  SingleListView.swift
//  The Big List
//
//  Created by Aahlad Madireddy on 7/4/20.
//

import SwiftUI

enum sheetType {
    case newListItem, editListItem
}

struct SingleListView : View {
    var list: BigList
    @EnvironmentObject var allLists: AppState
    @State private var currentListItems: [BigListItem] = []
    @State private var listItemToEdit: BigListItem = BigListItem.defaultBigListItem()
    @State private var showSheet: Bool = false
    @State private var selectedSheet: sheetType = sheetType.newListItem
    
    private func deleteRow(at indexSet: IndexSet) {
        print("hey")
    }
    
    private func refreshListItems() {
        withAnimation(.easeInOut(duration: 0.35)) {
            self.currentListItems = self.allLists.getListItems(listId: self.list.id)!
        }
    }

    var body: some View {
        return ScrollView() {
            VStack(alignment: .leading, spacing: 15) {
                if self.currentListItems.count > 0 {
                    ForEach(self.currentListItems, id: \.id) { listItem in
                        BigListRow(text: listItem.listText)
                            .contextMenu {
                                Button(action: {
                                    self.listItemToEdit = listItem
                                    self.selectedSheet = sheetType.editListItem
                                    self.showSheet = true
                                }) {
                                    HStack {
                                        Text("Edit item")
                                        Image(systemName: "square.and.pencil")
                                    }
                                }
                                Button(action: {
                                    _ = self.allLists.deleteListItem(listItemId: listItem.id)
                                    self.refreshListItems()
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
                } else {
                    Text("It's lonely here. Add a new item below!")
                        .font(.system(.body, design: .rounded))
                        .padding(.vertical)
                        .frame(alignment: .center)
                }
            }
            .frame(minWidth: 0, idealWidth: .infinity, maxWidth: .infinity, alignment: .leading)
            .padding(.horizontal)
        }
        .navigationBarTitle(list.listName)
        .toolbar(content: {
            Button(action: {
                self.selectedSheet = sheetType.newListItem
                self.showSheet = true
            }) {
                Text("New item").font(.system(.body, design: .rounded))
            }
        })
        .sheet(isPresented: $showSheet) {
            if self.selectedSheet == sheetType.newListItem {
                NewListItemForm(list: list).environmentObject(allLists)
                    .onDisappear() {
                        self.refreshListItems()
                    }
            }
            else if self.selectedSheet == sheetType.editListItem {
                EditListItemSheetView(listItem: self.$listItemToEdit).environmentObject(allLists)
                    .onDisappear() {
                        self.refreshListItems()
                    }
            }
        }
        .onAppear {
            self.refreshListItems()
        }
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
                    .navigationBarTitleDisplayMode(.inline)
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
