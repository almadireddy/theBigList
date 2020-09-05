//
//  EditListItemSheetView.swift
//  The Big List
//
//  Created by Aahlad Madireddy on 7/6/20.
//

import SwiftUI

struct EditListItemSheetView: View {
    var listName: String
    var selectedListItem: BigListItem
    
    @State var newListItemName: String = ""
    @State var newDueDate: Date = Date()
    @State var includeDueDate: Bool = false
    @State var dangerSheetPresented: Bool = false
    @State var newTagName: String = ""
    @State var newTagColor: BigListColor = .green
    @State var showNewTagField: Bool = false
    
    @Environment(\.presentationMode) var presentationMode
    @Environment(\.managedObjectContext) var moc
    @FetchRequest(entity: Tag.entity(), sortDescriptors: []) var allTags: FetchedResults<Tag>

    var body : some View {
        return NavigationView {
            VStack {
                Form {
                    Section(header: Text("List item name")) {
                        TextField("Edit list text", text: $newListItemName)
                            .font(.system(size: 18, weight: .semibold, design: .rounded))
                    }
                    
                    Section(header: Text("Basic details")) {
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
                            DatePicker("Due date", selection: self.$newDueDate, displayedComponents: .date)
                                .datePickerStyle(CompactDatePickerStyle())
                        }
                    }
                    
                    Section(header: Text("Tags")) {
                        ScrollView(.horizontal) {
                            LazyHGrid(rows: [
                                GridItem(.flexible()),
                                GridItem(.flexible())
                            ], alignment: .top, spacing: 0) {
                                ForEach(self.allTags, id: \.id) { t in
                                    Group {
                                        if self.selectedListItem.safeTags.contains(t) {
                                            InlineTag(tag: t)
                                                .overlay(RoundedRectangle(cornerRadius: 5).stroke(Color("TextColor"), lineWidth: 3))
                                                .onTapGesture {
                                                    moc.performAndWait {
                                                        self.selectedListItem.removeFromTags(t)
                                                        try? moc.save()
                                                    }
                                                }
                                            
                                        }
                                        else {
                                            InlineTag(tag: t)
                                                .onTapGesture {
                                                    moc.performAndWait {
                                                        self.selectedListItem.addToTags(t)
                                                        try? moc.save()
                                                    }
                                                }
                                        }
                                    }
                                    .padding(.horizontal, 4)
                                    .fixedSize(horizontal: false, vertical: true)
                                }
                            }
                            .padding(.vertical, 10)
                        }
                        .frame(minHeight: 90, maxHeight: 90)
                        
                        NavigationLink("Edit all tags", destination: AllTagsView())
                    }
                    
                    Section(header: Text("Danger")) {
                        Button(action: {
                            self.dangerSheetPresented = true
                        }) {
                            Text("Delete")
                                .foregroundColor(.red)
                        }
                    }
                    .actionSheet(isPresented: self.$dangerSheetPresented) {
                        ActionSheet(
                            title: Text("Confirm delete").font(.title2),
                            message: Text("You can't undo this"),
                            buttons: [
                                .destructive(Text("Delete"), action: {
                                    self.moc.delete(self.selectedListItem)
                                    try? self.moc.save()
                                    
                                    self.presentationMode.wrappedValue.dismiss()
                                }),
                                .cancel()
                            ]
                        )
                    }
                }
                .listStyle(GroupedListStyle())
                .environment(\.horizontalSizeClass, .regular)
                
                .navigationTitle("Editing List item")
                .navigationBarItems(trailing: Button(action: {
                    self.moc.performAndWait {
                        self.selectedListItem.listItemText = self.newListItemName
                        if self.includeDueDate {
                            self.selectedListItem.dueDate = self.newDueDate
                        } else {
                            self.selectedListItem.dueDate = nil
                        }
                        self.selectedListItem.updatedAt = Date()
                        
                        try? self.moc.save()
                    }
                    self.presentationMode.wrappedValue.dismiss()
                }) {
                    Text("Save")
                })
            }
        }
        .onAppear {
            self.newListItemName = self.selectedListItem.safeListItemText
            self.includeDueDate = self.selectedListItem.dueDate != nil
        }
    }
}
