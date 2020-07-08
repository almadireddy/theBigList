//
//  NewListButton.swift
//  The Big List
//
//  Created by Aahlad Madireddy on 7/5/20.
//

import SwiftUI

struct NewListButton: View {
    @Binding var showingDetail: Bool;
    @EnvironmentObject var myLists: AppState
    
    var body: some View {
        Button(action: {
            self.showingDetail = true
        }) {
            VStack() {
                Text("New")
                    .bold()
                    .foregroundColor(Color("TextColor"))
                    .font(.system(.headline, design: .rounded))
            }
            .frame(minWidth: /*@START_MENU_TOKEN@*/0/*@END_MENU_TOKEN@*/, idealWidth: .infinity, maxWidth: .infinity, minHeight: 60, idealHeight: 60, maxHeight: 60, alignment: .bottomLeading)
        }
        .padding(.all, 10.0)
        .background(Color("ThemeBg"))
        .cornerRadius(10.0)
        .sheet(isPresented: $showingDetail) {
            NewBigListForm().environmentObject(myLists)
        }
    }
}
