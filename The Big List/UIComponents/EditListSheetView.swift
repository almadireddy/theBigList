//
//  RenameListSheetView.swift
//  The Big List
//
//  Created by Aahlad Madireddy on 7/5/20.
//

import SwiftUI

struct EditListSheetView: View {
    @Binding var list: BigList
    @State var newListName: String = ""
    @EnvironmentObject var appState: AppState
    @Environment(\.presentationMode) var presentationMode

    var body : some View {
        return NavigationView {
            ScrollView {
                VStack() {
                    Spacer()
                    BigTextField(enteredText: $newListName, placeholder: "New list name", onEditCommit: {
                        print(self.newListName)
                    })
                }
            }
            .onAppear() {
                self.newListName = list.listName
            }
            .navigationTitle("Editing List")
            .navigationBarTitleDisplayMode(.inline)
            .navigationBarItems(trailing: Button(action: {
                let worked = appState.renameList(listId: list.id, newListName: self.newListName)
                print("\(worked)")
                _ = appState.refreshLists()
                presentationMode.wrappedValue.dismiss()
            }) {
                Text("Save")
            })
        }
    }
}
