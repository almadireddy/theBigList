//
//  EditTag.swift
//  The Big List
//
//  Created by Aahlad Madireddy on 7/21/20.
//

import SwiftUI

struct AllTagsView: View {
    @Environment(\.managedObjectContext) var moc
    @FetchRequest(entity: Tag.entity(), sortDescriptors: []) var allTags: FetchedResults<Tag>

    @State private var action: UUID? = UUID()

    var body: some View {
        List {
            ForEach(self.allTags, id: \.id) { t in
                NavigationLink(destination: EditTagView(tag: t),
                               tag: t.id ?? UUID(),
                               selection: $action) {
                    Button(action: {
                        self.action = t.id ?? UUID()
                    }) {
                        HStack {
                            Circle()
                                .fill(TagColors.getColor(color: BigListColor(rawValue: t.safeColor) ?? .green))
                                .frame(width: 20, height: 20)
                            Text(t.safeTagName)
                        }
                    }
                    .padding(.vertical, 10)
                }
            }
        }
        .navigationBarTitle("Tags")
        .navigationBarTitleDisplayMode(.large)
        .navigationBarItems(trailing: NavigationLink(destination: NewTag()) {
                HStack() {
                    Image(systemName: "plus.circle.fill")
                }
            }
        )
    }
}

struct EditTagView : View {
    var tag: Tag
    @State var newTagName : String
    @State var newTagColor : BigListColor
    @State var showDeleteConfirm: Bool = false
    
    init(tag: Tag) {
        self.tag = tag
        self._newTagColor = State(initialValue: BigListColor(rawValue: tag.safeColor) ?? .green)
        self._newTagName = State(initialValue: tag.safeTagName)
    }
    
    @Environment(\.managedObjectContext) var moc
    @Environment(\.presentationMode) var presentationMode: Binding<PresentationMode>

    var body: some View {
        VStack {
            Form {
                Section(header: Text("Basics")) {
                    EditTagForm(newTagName: self.$newTagName, newTagColor: self.$newTagColor)
                }
                
                Section(header: Text("Danger")) {
                    Button(action: {
                        self.showDeleteConfirm = true
                    }) {
                        Text("Delete tag")
                            .foregroundColor(.red)
                    }
                    .actionSheet(isPresented: self.$showDeleteConfirm) {
                        ActionSheet(
                            title: Text("Confirm delete").font(.title2),
                            message: Text("This will remove the tag from all items it's attached to."),
                            buttons: [
                                .destructive(Text("Delete"), action: {
                                    self.moc.delete(self.tag)
                                    try? self.moc.save()
                                    
                                    self.presentationMode.wrappedValue.dismiss()
                                }),
                                .cancel()
                            ]
                        )
                    }
                }
            }
            .listStyle(GroupedListStyle())
            .environment(\.horizontalSizeClass, .regular)
  
        }
        .navigationBarItems(trailing: Button(action: {
            if newTagName.count == 0 {
                self.presentationMode.wrappedValue.dismiss()
                return
            }
            self.moc.performAndWait {
                tag.color = newTagColor.rawValue
                tag.tagName = newTagName
                
                try? self.moc.save()
            }
            self.presentationMode.wrappedValue.dismiss()
        }) {
            Text("Save changes")
        })
        .navigationBarTitle("Editing tag")
        
    }
}

struct EditTagForm : View {
    @Binding var newTagName : String
    @Binding var newTagColor : BigListColor
    
    var body: some View {
        TextField("Tag name", text: $newTagName)
        ColorChooser(selectedColor: self.$newTagColor)
            .padding(.vertical)
    }
}
