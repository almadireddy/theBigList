//
//  GradientButtonStyle.swift
//  The Big List
//
//  Created by Aahlad Madireddy on 7/5/20.
//

import Foundation
import SwiftUI

struct GradientButtonStyle: ButtonStyle {
    var color: BigListColor
    
    init(color: BigListColor) {
        self.color = color
    }
    
    func makeBody(configuration: Self.Configuration) -> some View {
        configuration.label
            .foregroundColor(Color.white)
            .padding(.all, 10)
            .background(
                LinearGradient(gradient: BigListColorGradients.getGradient(color: color),
                               startPoint: .leading,
                               endPoint: .trailing)
            )
            .cornerRadius(10)
    }
}
