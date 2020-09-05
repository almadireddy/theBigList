//
//  NewTag.swift
//  The Big List
//
//  Created by Aahlad Madireddy on 7/21/20.
//

import SwiftUI

struct NewTag: View {
    @State var newTagName : String = ""
    @State var newTagColor : BigListColor = .green
    @State var showDeleteConfirm: Bool = false
    
    @Environment(\.managedObjectContext) var moc
    @Environment(\.presentationMode) var presentationMode: Binding<PresentationMode>

    func saveTag() {
        if self.newTagName.count == 0 {
            return
        }
        
        let newTag = Tag(context: moc)
        newTag.color = self.newTagColor.rawValue
        newTag.id = UUID()
        newTag.tagName = self.newTagName
    }
    
    var body: some View {
        VStack {
            Form {
                Section(header: Text("Basics")) {
                    EditTagForm(newTagName: self.$newTagName, newTagColor: self.$newTagColor)
                }
                
                Section(header: Text("Save Changes")) {
                    Button(action: {
                        saveTag()
                        self.presentationMode.wrappedValue.dismiss()
                    }) {
                        Text("Save new tag")
                    }
                }
            }
            .listStyle(GroupedListStyle())
            .environment(\.horizontalSizeClass, .regular)
  
        }
        .navigationBarItems(trailing: Button(action: {
            saveTag()
            self.presentationMode.wrappedValue.dismiss()
        }) {
            Text("Save changes")
        })
        .navigationBarTitle("New Tag")
        
    }
}
