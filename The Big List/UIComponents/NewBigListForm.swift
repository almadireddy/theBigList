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
    @State var selectedColor = BigListColor.green
    
    @Environment(\.managedObjectContext) var moc
    
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
                        Text(listNameError)
                            .foregroundColor(.red).font(.system(.body, design: .rounded))
                            .multilineTextAlignment(.center)
                            .padding(.bottom, 25)
                            .frame(minWidth: 0, idealWidth: .infinity, maxWidth: .infinity)
                    }
                    
                    ColorChooser(selectedColor: self.$selectedColor)
                        .frame(minWidth: 0, idealWidth: .infinity, maxWidth: .infinity)
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
                    let newBigList = BigList(context: moc)
                    newBigList.id = UUID()
                    newBigList.listName = self.enteredText
                    newBigList.color = self.selectedColor.rawValue
                    
                    do {
                        try self.moc.save()
                    } catch {
                        print("couldn't save: \(error)")
                    }
                    self.presentationMode.wrappedValue.dismiss()
                }
            }) {
                Text("Save")
            })
        }
        
    }
}
