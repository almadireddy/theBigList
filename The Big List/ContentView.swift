//
//  ContentView.swift
//  The Big List
//
//  Created by Aahlad Madireddy on 6/30/20.
//

import SwiftUI
import CoreData
import Foundation

struct ContentView: View {
    @State var showAlert = false
    @State private var showActionSheet = false
    @State var showingDetail = false
    @State var showRenameSheet = false
    @State private var action: UUID? = UUID()
    
    @Environment(\.managedObjectContext) var moc
    @FetchRequest(entity: BigList.entity(), sortDescriptors: []) var bigLists: FetchedResults<BigList>
    
    var body: some View {
        return NavigationView() {
            ScrollView() {
                LazyVGrid(columns: [
                    GridItem(.flexible()),
                    GridItem(.flexible())
                ], alignment: .leading, spacing: 10.0) {
                    ForEach(bigLists, id: \.id) { list in
                        NavigationLink(destination: SingleListView(list: list),
                                       tag: list.id ?? UUID(),
                                       selection: $action) {
                            Button(action: {
                                self.action = list.id ?? UUID()
                            }) {
                                VStack() {
                                    Text("\(list.listName ?? "none")")
                                        .bold()
                                        .foregroundColor(.white)
                                        .font(.system(.headline, design: .rounded))
                                }
                                .frame(minWidth: 0, idealWidth: .infinity, maxWidth: .infinity, minHeight: 60, idealHeight: 60, maxHeight: 60, alignment: .bottomLeading)
                            
                            }
                            .buttonStyle(GradientButtonStyle(color: BigListColor(rawValue: list.safeColor) ?? BigListColor.green))
                            .contextMenu() {
                                Button(action: {
                                    print("edit")
                                }) {
                                    HStack {
                                        Text("Edit list")
                                        Image(systemName: "square.and.pencil")
                                    }
                                }
                                Button(action: {
                                    print("delete")
                                }) {
                                    HStack {
                                        Text("Delete list")
                                        Image(systemName: "trash")
                                    }
                                }
                            }
                            .sheet(isPresented: self.$showRenameSheet) {
                                Text("hey")
                            }
                        }
                    }
                    NewListButton(showingDetail: self.$showingDetail)
                }
            }
            .padding(.horizontal, 20)
            .navigationBarTitle("The Big List")
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
