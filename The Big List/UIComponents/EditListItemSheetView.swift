//
//  EditListItemSheetView.swift
//  The Big List
//
//  Created by Aahlad Madireddy on 7/6/20.
//

import SwiftUI

struct EditListItemSheetView: View {
    var listName: String
    @State var newListItemName: String = ""
    @Environment(\.presentationMode) var presentationMode
    @Environment(\.managedObjectContext) var moc

    var body : some View {
        return NavigationView {
            ScrollView {
                VStack() {
                    BigTextField(enteredText: $newListItemName, placeholder: "Edit list name", onEditCommit: {
                        print(self.newListItemName)
                    })
                }
            }
            .navigationTitle("Editing List item")
            .navigationBarTitleDisplayMode(.inline)
            .navigationBarItems(trailing: Button(action: {
                self.presentationMode.wrappedValue.dismiss()
            }) {
                Text("Save")
            })
        }
    }
}
