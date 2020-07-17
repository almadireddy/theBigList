//
//  SingleListView.swift
//  The Big List
//
//  Created by Aahlad Madireddy on 7/4/20.
//

import SwiftUI

struct SingleListView : View {
    var listName: String
    var items: Array<BigListItem>
    @State private var showSheet: Bool = false
    @State private var selectedItem: BigListItem = BigListItem()
    
    @EnvironmentObject private var store : AppStore
    
    @Environment(\.managedObjectContext) var moc
    
    var body: some View {
        return ScrollView() {
            VStack(spacing: 15) {
                ForEach(self.items, id: \.id) { item in
                    BigListRow(listItem: item,
                               editSheetPresented: self.$showSheet,
                               selectedItem: self.$selectedItem)
                }
            
                if self.items.count == 0 {
                    Text("It's lonely here. Add a new item below!")
                        .font(.system(.body, design: .rounded))
                        .padding(.vertical)
                        .frame(alignment: .center)
                }
            }
        }
        
        .navigationBarTitle(listName)
        .toolbar {
            ToolbarItem(placement: .bottomBar) {
                Button(action: {
                    self.store.setSelectedSheet(.newListItem)
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
                    self.store.setSelectedSheet(.listSettings)
                    self.showSheet = true
                }) {
                    Image(systemName: "gear")
                }
                .padding(.vertical)
            }
        }
        .sheet(isPresented: self.$showSheet) {
            if self.store.state.selectedSheet == SheetType.newListItem {
                NewListItemForm(listName: self.listName).environment(\.managedObjectContext, self.moc)
            }
            else if self.store.state.selectedSheet == SheetType.editListItem {
                EditListItemSheetView(listName: self.listName,
                                      selectedListItem: self.selectedItem)
                    .environment(\.managedObjectContext, self.moc)
            }
            else if self.store.state.selectedSheet == SheetType.listSettings {
                Text("hm")
            }
        }
    }
}

struct NewListItemForm: View {
    var listName: String = ""
    @State private var newItemText: String = ""
    @State private var newItemDueDate: Date = Date(timeIntervalSinceNow: 0)

    @Environment(\.presentationMode) var presentationMode
    @Environment(\.managedObjectContext) var moc
    @FetchRequest(entity: BigList.entity(), sortDescriptors: []) var allLists: FetchedResults<BigList>
    
    var body: some View {
        return NavigationView() {
            ScrollView() {
                VStack(alignment: .leading) {
                    BigTextField(enteredText: $newItemText, placeholder: "New item" , onEditCommit: {
                        self.newItemText = newItemText.trimmingCharacters(in: .whitespaces)
                    })
                    .padding(.top)
                    VStack {
                        Text("Due Date")
                            .font(.system(.body, design: .rounded))
                            .bold()
                        DatePicker("Due Date", selection: $newItemDueDate, displayedComponents: .date)
                            .labelsHidden()
                    }
                    .padding(.horizontal)
                        
                    .navigationBarTitle("New list item")
                    .navigationBarTitleDisplayMode(.inline)
                    .navigationBarItems(trailing:
                        Button(action: {
                            if self.newItemText.count == 0 {
                                return
                            }
                            let newListItem = BigListItem(context: moc)
                            let parentList = allLists.first(where: { l in
                                return l.listName ?? "" == self.listName
                            })
                            
                            newListItem.listItemText = self.newItemText
                            newListItem.id = UUID()
                            newListItem.createdAt = Date()
                            newListItem.dueDate = self.newItemDueDate
                            newListItem.isComplete = false
                            
                            parentList?.addToListItems(newListItem)
                            
                            
                            do {
                               try moc.save()
                            } catch {
                                print("couldn't save item : \(error)")
                            }
                            
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
