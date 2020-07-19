//
//  ColorChooser.swift
//  The Big List
//
//  Created by Aahlad Madireddy on 7/18/20.
//

import Foundation
import SwiftUI

struct ColorChooser : View {
    @Binding var selectedColor: BigListColor
    
    var body : some View {
        HStack(alignment: .center, spacing: 15) {
            ForEach(BigListColor.allCases, id: \.self) { color in
                Button(action: {
                    self.selectedColor = color
                }) {
                    if color == self.selectedColor {
                        Circle()
                            .fill(LinearGradient(gradient: BigListColorGradients.getGradient(color: color), startPoint: .leading, endPoint: .trailing))
                            .overlay(Circle().stroke(Color("TextColor"), lineWidth: 3))
                            .frame(width: 50, height: 50)
                            
                    } else {
                        Circle()
                            .fill(LinearGradient(gradient: BigListColorGradients.getGradient(color: color), startPoint: .leading, endPoint: .trailing))
                            .frame(width: 50, height: 50)
                    }
                    
                }
                .buttonStyle(BorderlessButtonStyle())
            }
        }
    }
}
