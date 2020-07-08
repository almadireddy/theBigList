//
//  EditListItemSheetView.swift
//  The Big List
//
//  Created by Aahlad Madireddy on 7/6/20.
//

import SwiftUI

struct EditListItemSheetView: View {
    @Binding var listItem: BigListItem
    @State var newListItemName: String = ""
    
    var body : some View {
        return NavigationView {
            ScrollView {
                VStack() {
                    BigTextField(enteredText: $newListItemName, placeholder: "New list name", onEditCommit: {
                        print(self.newListItemName)
                    })
                }
            }
            .navigationTitle("Editing List")
            .navigationBarTitleDisplayMode(.inline)
            .navigationBarItems(trailing: Button(action: {
                print("\(newListItemName)")
            }) {
                Text("Save")
            })
        }
    }
}
