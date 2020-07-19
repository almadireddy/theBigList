//
//  BigListRow.swift
//  The Big List
//
//  Created by Aahlad Madireddy on 7/8/20.
//

import SwiftUI

struct BigListRow: View {
    @ObservedObject var listItem: BigListItem
    @Binding var editSheetPresented: Bool
    @Binding var selectedItem: BigListItem
    @EnvironmentObject private var store: AppStore
    
    @Environment(\.managedObjectContext) var moc
    
    var body: some View {
        HStack {
            VStack {
                HStack {
                    if self.listItem.dueDate != nil {
                        Text("Due \(self.listItem.safeDueDate, formatter: taskDateFormat)")
                            .multilineTextAlignment(.leading)
                            .font(.system(size: 15, weight: .light, design: .rounded))
                        Spacer()
                    }
                    
                }
                
                HStack {
                    Button(action: {
                        let newValue = !self.listItem.isComplete
                        
                        moc.performAndWait {
                            listItem.isComplete = newValue
                            try? moc.save()
                        }
                    }) {
                        if self.listItem.isComplete {
                            Image(systemName: "checkmark.circle.fill")
                                .imageScale(.large)
                        } else {
                            Image(systemName: "circle")
                                .imageScale(.large)
                        }
                    }
                    .foregroundColor(Color("TextColor"))
                    
                    Text(listItem.safeListItemText)
                        .font(.system(size: 18, weight: .regular, design: .rounded))
                        .multilineTextAlignment(.leading)
                        .frame(minWidth: 0,
                               idealWidth: .infinity,
                               maxWidth: .infinity,
                               alignment: .leading)
                    
                    Spacer()
                }
            }
            
            HStack {
                Button(action: {
                    self.store.setSelectedSheet(.editListItem)
                    self.selectedItem = self.listItem
                    self.editSheetPresented = true
                }) {
                    Image(systemName: "square.and.pencil")
                        .imageScale(.large)
                }
                .foregroundColor(Color("TextColor"))
            }
        }
        .padding(.all)
        .background(Color("ThemeBg"))
        .cornerRadius(15)
    }
}
