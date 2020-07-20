//
//  SingleListView.swift
//  The Big List
//
//  Created by Aahlad Madireddy on 7/4/20.
//

import SwiftUI

struct SingleListView : View {
    var list: BigList
    private var listName: String
    private var items: Array<BigListItem>
    @State private var showSheet: Bool = false
    @State private var selectedItem: BigListItem = BigListItem()
    
    @EnvironmentObject private var store : AppStore
    
    @Environment(\.managedObjectContext) var moc
    
    init(list: BigList) {
        self.list = list
        self.listName = list.safeListName
        self.items = list.listItemArray
    }
    
    var body: some View {
        return ScrollView() {
            VStack(alignment: .leading, spacing: 15) {
                if self.items.count > 0 {
                    ForEach(self.items, id: \.id) { item in
                        BigListRow(listItem: item,
                                   editSheetPresented: self.$showSheet,
                                   selectedItem: self.$selectedItem)
                    }
                } else {
                    Text("It's lonely here. Add a new item below!")
                        .font(.system(.body, design: .rounded))
                        .padding(.vertical)
                        .frame(alignment: .center)
                }
            }
            .padding(.horizontal)
            .frame(minWidth: 0, idealWidth: .infinity, maxWidth: .infinity, alignment: .leading)
            .navigationBarTitle(listName)
        }
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
                ListSettingsForm(list: self.list)
                    .environment(\.managedObjectContext, self.moc)

            }
        }
    }
}

struct ListSettingsForm : View {
    var list: BigList = BigList()
    
    @State private var newListName = ""
    @State private var newColor = BigListColor.green
    @Environment(\.managedObjectContext) var moc
    @Environment(\.presentationMode) var presentationMode

    var body : some View {
        NavigationView() {
            VStack {
                Form {
                    Section(header: Text("Basics")) {
                        TextField("List name", text: self.$newListName)
                            .font(.system(size: 20, weight: .semibold, design: .rounded))
                        ColorChooser(selectedColor: self.$newColor)
                            .padding(.vertical)
                    }
                    
                }
                .listStyle(GroupedListStyle())
                .environment(\.horizontalSizeClass, .regular)
            }
            .navigationBarTitle("Editing list")
            .navigationBarItems(trailing:
                Button(action: {
                    moc.performAndWait {
                        self.list.color = newColor.rawValue
                        self.list.listName = newListName
                        self.list.updatedAt = Date()
                        
                        try? moc.save()
                        presentationMode.wrappedValue.dismiss()
                    }
                }) {
                    Text("Save changes")
                }
            )
        }
        .onAppear {
            self.newColor = BigListColor(rawValue: list.safeColor) ?? BigListColor.green
            self.newListName = list.safeListName
        }
    }
}

struct NewListItemForm: View {
    var listName: String = ""
    @State private var newItemText: String = ""
    @State private var newItemDueDate: Date = Date()
    
    @State private var includeDueDate: Bool = false
    
    @Environment(\.presentationMode) var presentationMode
    @Environment(\.managedObjectContext) var moc
    @FetchRequest(entity: BigList.entity(), sortDescriptors: []) var allLists: FetchedResults<BigList>
    
    var body: some View {
        return NavigationView() {
            VStack(alignment: .leading) {
                Form {
                    Section(header: Text("List item name")) {
                        TextField("Item text", text: $newItemText)
                            .font(.system(size: 18, weight: .semibold, design: .rounded))
                    }
                    Section(header: Text("Basic Details")) {
                        Button(action: {
                            let newValue = !self.includeDueDate
                            self.includeDueDate = newValue
                        }) {
                            if self.includeDueDate {
                                HStack {
                                    Image(systemName: "calendar.badge.minus")
                                    Text("Remove due date")
                                }
                            }
                            else {
                                HStack {
                                    Image(systemName: "calendar.badge.plus")
                                    Text("Add due date")
                                }
                            }
                        }
                        
                        if self.includeDueDate {
                            DatePicker("Due date", selection: self.$newItemDueDate, displayedComponents: .date)
                                .datePickerStyle(CompactDatePickerStyle())
                        }
                    }
                }
                .listStyle(GroupedListStyle())
                .environment(\.horizontalSizeClass, .regular)
                .navigationBarTitle("New list item")
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
                        newListItem.isComplete = false
                        newListItem.dueDate = nil
                        
                        if self.includeDueDate == true {
                            newListItem.dueDate = self.newItemDueDate
                        }
                        
                        let sampleTag = Tag(context: moc)
                        
                        sampleTag.tagName = "testTag"
                        sampleTag.id = UUID()
                        sampleTag.color = "green"
                        
                        newListItem.addToTags(sampleTag)
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
