//
//  BigTextField.swift
//  The Big List
//
//  Created by Aahlad Madireddy on 7/3/20.
//

import SwiftUI

struct BigTextField: View {
    @Binding var enteredText : String
    var placeholder: String
    var onEditCommit : () -> Void
    
    var body: some View {
        TextField(placeholder, text: $enteredText, onCommit: {
            onEditCommit()
        })
        .padding(.all)
        .font(.system(.largeTitle, design: .rounded))
        .multilineTextAlignment(.center)
        .background(Color.clear)
    }
}
