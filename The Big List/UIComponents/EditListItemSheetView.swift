//
//  EditListItemSheetView.swift
//  The Big List
//
//  Created by Aahlad Madireddy on 7/6/20.
//

import SwiftUI

struct EditListItemSheetView: View {
    var listItem: BigListItem
    @State var newListItemName: String = ""
    @EnvironmentObject var appState: AppState
    @Environment(\.presentationMode) var presentationMode

    var body : some View {
        return NavigationView {
            ScrollView {
                VStack() {
                    BigTextField(enteredText: $newListItemName, placeholder: "New list name", onEditCommit: {
                        print(self.newListItemName)
                    })
                }
            }
            .onAppear() {
                print(self.listItem.listText)
                self.newListItemName = self.listItem.listText
            }
            .navigationTitle("Editing List item")
            .navigationBarTitleDisplayMode(.inline)
            .navigationBarItems(trailing: Button(action: {
                let worked = self.appState.renameListItem(listItemId: self.listItem.id, newListItemText: self.newListItemName)
                print(worked)
                self.presentationMode.wrappedValue.dismiss()
            }) {
                Text("Save")
            })
        }
    }
}
