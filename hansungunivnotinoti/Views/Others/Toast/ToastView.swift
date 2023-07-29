//
//  ToastView.swift
//  hansungunivnotinoti
//
//  Created by Finny Jakey on 2023/07/29.
//

import SwiftUI

struct ToastView: View {
    
    var style: ToastStyle
    var message: String
    var width = CGFloat.infinity
    var onCancelTapped: (() -> Void)
    
    var body: some View {
        HStack(alignment: .center, spacing: 12) {
            Image(systemName: style.iconFileName)
                .foregroundColor(style.themeColor)
            Text(message)
                .font(.subheadline)
                .foregroundColor(Color.primary)
            
            Spacer(minLength: 10)
            
            Button {
                onCancelTapped()
            } label: {
                Image(systemName: "xmark")
                    .foregroundColor(style.themeColor)
            }
        }
        .padding()
        .frame(minWidth: 0, maxWidth: width)
        .background(.thinMaterial.opacity(0.9))
        .cornerRadius(8)
        .overlay(
            RoundedRectangle(cornerRadius: 8)
                .stroke(style.themeColor, lineWidth: 0.5)
                .opacity(0.6)
        )
        .padding(.horizontal, 16)
    }
}
