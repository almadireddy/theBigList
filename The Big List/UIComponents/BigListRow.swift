//
//  BigListRow.swift
//  The Big List
//
//  Created by Aahlad Madireddy on 7/8/20.
//

import SwiftUI

struct BigListRow: View {
    var listItem: BigListItem
    @Binding var editSheetPresented: Bool
    @EnvironmentObject private var store: AppStore

    var body: some View {
        HStack {
            Button(action: {
                self.store.setSelectedSheet(.editListItem)
                self.editSheetPresented = true
            }) {
                Text(listItem.safeListItemText)
                    .font(.system(.title2, design: .rounded))
                    .multilineTextAlignment(.leading)
                    .frame(minWidth: 0,
                           idealWidth: .infinity,
                           maxWidth: .infinity,
                           minHeight: 60,
                           alignment: .leading)
//                    .padding(.horizontal)
//                    .background(Color("ThemeBg"))
//                    .foregroundColor(.white)
//                    .cornerRadius(15)
            }
        }
    }
}
