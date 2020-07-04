//
//  NewBigListForm.swift
//  The Big List
//
//  Created by Aahlad Madireddy on 7/4/20.
//

import SwiftUI

struct NewBigListForm: View {
    @State var enteredText = ""
    @Environment(\.presentationMode) var presentationMode
    @State var listNameError = ""
    @State var description = ""
    @EnvironmentObject var allLists: AppState
    
    var body: some View {
        NavigationView() {
            ScrollView() {
                VStack(alignment: .leading) {
                    Spacer(minLength: 15)
                    BigTextField(enteredText: $enteredText, placeholder: "New list name", onEditCommit: {
                        if (self.enteredText.count == 0) {
                            self.listNameError = "Please enter a name"
                        } else {
                            self.listNameError = ""
                        }
                    })
                    .padding(.vertical, 25)
                    
                    if (listNameError.count > 0) {
                        Text(listNameError).foregroundColor(.red).font(.body)
                    }
                    
                    TextEditor(text: $description)
                        .frame(height: 150)
                        .padding(.all)
                        .border(Color("ThemeBg"), width: 2)
                        
                }
                .padding(.horizontal, 15)
                .padding(.bottom, 35)
            }
            .navigationBarTitle("New big list")
            .navigationBarTitleDisplayMode(.inline)
            .navigationBarItems(trailing: Button(action: {
                if (enteredText.trimmingCharacters(in: .whitespaces).count == 0) {
                    listNameError = "Please enter a name"
                } else {
                    _ = self.allLists.addNewList(listName: enteredText.trimmingCharacters(in: .whitespaces))
                    _ = self.allLists.refreshLists()
                    self.presentationMode.wrappedValue.dismiss()
                }
            }) {
                Text("Save")
            })
        }
        
    }
}
