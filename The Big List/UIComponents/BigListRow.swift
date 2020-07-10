//
//  BigListRow.swift
//  The Big List
//
//  Created by Aahlad Madireddy on 7/8/20.
//

import SwiftUI

struct BigListRow: View {
    var listItem: BigListItem
    @Binding var listItemToEdit: BigListItem
    @Binding var editSheetPresented: Bool
    @Binding var sheetType: SheetType
    @EnvironmentObject var appState: AppState

    var body: some View {
        HStack {
            Text(listItem.listText)
                .font(.system(.title2, design: .rounded))
                .multilineTextAlignment(.leading)
                .frame(minWidth: 0,
                       idealWidth: .infinity,
                       maxWidth: .infinity,
                       minHeight: 60,
                       alignment: .leading)
                .padding(.horizontal)
                .background(Color("ThemeBg"))
                .cornerRadius(15)
        }
        .contextMenu {
            Button(action: {
                self.sheetType = SheetType.editListItem
                self.listItemToEdit = self.listItem
                self.editSheetPresented = true
            }) {
                HStack {
                    Text("Edit item")
                    Image(systemName: "square.and.pencil")
                }
            }
            Button(action: {
                _ = self.appState.deleteListItem(listItemId: self.listItem.id)
            }) {
                HStack {
                    Text("Delete list item")
                        .foregroundColor(Color.red)
                    Image(systemName: "trash")
                }
            }
        }
        .sheet(isPresented: $editSheetPresented) {
            EditListItemSheetView(listItem: self.listItem).environmentObject(appState)
        }
    }
}
