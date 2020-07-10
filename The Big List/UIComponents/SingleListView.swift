//
//  SingleListView.swift
//  The Big List
//
//  Created by Aahlad Madireddy on 7/4/20.
//

import SwiftUI

enum SheetType {
    case newListItem, editListItem
}

struct SingleListView : View {
    var list: BigList
    @EnvironmentObject var allLists: AppState
    @State private var currentListItems: [BigListItem] = []
    @State private var listItemToEdit: BigListItem = BigListItem.defaultBigListItem()
    @State private var showSheet: Bool = false
    @State private var selectedSheet: SheetType = SheetType.newListItem
    
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
            VStack(spacing: 15) {
                if self.currentListItems.count > 0 {
                    ForEach(self.currentListItems, id: \.id) { listItem in
                        BigListRow(listItem: listItem, listItemToEdit: self.$listItemToEdit, editSheetPresented: self.$showSheet, sheetType: self.$selectedSheet)
                    }
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
        .toolbar {
            ToolbarItem(placement: .bottomBar) {
                Button(action: {
                    self.selectedSheet = SheetType.newListItem
                    self.showSheet = true
                }) {
                    HStack {
                        Image(systemName: "plus.circle.fill")
                        Text("New item")
                            .font(.system(size: 18, weight: .bold, design: .rounded))
                    }
                }
                .padding(.vertical)
            }
            ToolbarItem(placement: .navigationBarTrailing) {
                Button(action: {
                    self.selectedSheet = SheetType.newListItem
                    self.showSheet = true
                }) {
                    Image(systemName: "gear")
                }
                .padding(.vertical)
            }
        }
        .sheet(isPresented: $showSheet) {
            if self.selectedSheet == SheetType.newListItem {
                NewListItemForm(list: list).environmentObject(allLists)
                    .onDisappear() {
                        self.refreshListItems()
                    }
            }
            else if self.selectedSheet == SheetType.editListItem {
                EditListItemSheetView(listItem: self.listItemToEdit).environmentObject(allLists)
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
