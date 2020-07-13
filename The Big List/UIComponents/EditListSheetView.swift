//
//  RenameListSheetView.swift
//  The Big List
//
//  Created by Aahlad Madireddy on 7/5/20.
//

import SwiftUI

struct EditListSheetView: View {
    @Binding var list: BigListOld
    @State var newListName: String = ""
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
                
                presentationMode.wrappedValue.dismiss()
            }) {
                Text("Save")
            })
        }
    }
}
