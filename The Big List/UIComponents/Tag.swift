//
//  Tag.swift
//  The Big List
//
//  Created by Aahlad Madireddy on 7/19/20.
//

import SwiftUI

struct InlineTag : View {
    var tag: Tag
    
    var body : some View {
        HStack {
            Image(systemName: "tag.fill")
                .imageScale(.small)
            Text(tag.safeTagName)
                .font(.system(size: 16, weight: .light, design: .rounded))
        }
        .padding(.horizontal, 10)
        .padding(.vertical, 5)
        .foregroundColor(.white)
        .background(TagColors.getColor(color: BigListColor(rawValue: tag.safeColor) ?? .green).opacity(0.75))
        .cornerRadius(5)
    }
}
