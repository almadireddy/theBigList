//
//  BigListRow.swift
//  The Big List
//
//  Created by Aahlad Madireddy on 7/8/20.
//

import SwiftUI

struct BigListRow: View {
    var text: String;
    
    var body: some View {
        Text(text)
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
}
