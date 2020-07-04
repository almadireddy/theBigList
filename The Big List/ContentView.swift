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
    
    var body: some View {
        return NavigationView {
            ScrollView() {
                LazyVGrid(columns: [
                    GridItem(.flexible()),
                    GridItem(.flexible())
                ], alignment: .leading, spacing: 10.0) {
                    ForEach(self.myLists.lists, id: \.self) { list in
                        NavigationLink(destination: SingleListView(list: list)) {
                            VStack() {
                                Text("\(list.listName)")
                                    .bold()
                                    .foregroundColor(Color("TextColor"))
                                    .font(.system(.headline, design: .rounded))
                            }
                            .frame(minWidth: 0, idealWidth: .infinity, maxWidth: .infinity, minHeight: 60, idealHeight: 60, maxHeight: 60, alignment: .bottomLeading)
                        }
                        .padding(.all, 10)
                        .background(LinearGradient(
                                        gradient: Gradient(colors: [Color("DarkGreen"), Color("LightGreen")]),
                                        startPoint: .topLeading,
                                        endPoint: .bottomTrailing))
                        .cornerRadius(10.0)
                        .contextMenu() {
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
                    }
                    
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
                .padding(.trailing)
            }
            .navigationBarTitle("The Big List")
            .padding(.horizontal, 20.0)
            .frame(minWidth: 0, idealWidth: .infinity, maxWidth: .infinity, minHeight: 0, idealHeight: .infinity, maxHeight: .infinity, alignment: .bottomLeading)
        }
        .frame(minWidth: 0, idealWidth: .infinity, maxWidth: .infinity, minHeight: 0, idealHeight: 100, maxHeight: .infinity, alignment: .topLeading)
    }
}

struct ContentView_Previews: PreviewProvider {
    static var sampleState = AppState()
    static var previews: some View {
        ContentView().environmentObject(sampleState)
    }
}
