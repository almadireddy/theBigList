//
//  ContentView.swift
//  The Big List
//
//  Created by Aahlad Madireddy on 6/30/20.
//

import SwiftUI

struct ContentView: View {
    @State var showAlert = false
    @EnvironmentObject var myLists: AppState
    @State private var showActionSheet = false
    @State var showingDetail = false
    @State var showRenameSheet = false
    @State private var action: Int? = 0
    @State var listToRename: BigList = BigList.defaultBigList()
    
    var body: some View {
        return NavigationView {
            ScrollView() {
                LazyVGrid(columns: [
                    GridItem(.flexible()),
                    GridItem(.flexible())
                ], alignment: .leading, spacing: 10.0) {
                    ForEach(self.myLists.lists, id: \.self) { list in
                        NavigationLink(destination: SingleListView(list: list), tag: Int(list.id), selection: $action) {
                            Button(action: {
                                self.action = Int(list.id)
                            }) {
                                VStack() {
                                    Text("\(list.listName)")
                                        .bold()
                                        .foregroundColor(Color("TextColor"))
                                        .font(.system(.headline, design: .rounded))
                                }
                                .frame(minWidth: 0, idealWidth: .infinity, maxWidth: .infinity, minHeight: 60, idealHeight: 60, maxHeight: 60, alignment: .bottomLeading)
                            
                            }
                            .buttonStyle(GradientButtonStyle())
                            .contextMenu() {
                                Button(action: {
                                    self.listToRename = list
                                    self.showRenameSheet = true
                                }) {
                                    HStack {
                                        Text("Edit list")
                                        Image(systemName: "square.and.pencil")
                                    }
                                }
                                Button(action: {
                                    _ = self.myLists.deleteList(listName: list.listName)
                                    _ = self.myLists.refreshLists()
                                }) {
                                    HStack {
                                        Text("Delete list")
                                        Image(systemName: "trash")
                                    }
                                }
                            }
                            .sheet(isPresented: self.$showRenameSheet) {
                                EditListSheetView(list: self.$listToRename).environmentObject(myLists)
                            }
                        }
                    }
                    NewListButton(showingDetail: self.$showingDetail)
                }
                .padding(.trailing)
            }
            .navigationBarTitle("The Big List")
            .padding(.horizontal, 20.0)
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var sampleState = AppState()
    static var previews: some View {
        ContentView().environmentObject(sampleState)
    }
}
