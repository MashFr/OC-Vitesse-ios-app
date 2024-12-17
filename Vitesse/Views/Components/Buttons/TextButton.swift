//
//  TextButton.swift
//  Vitesse
//
//  Created by Tony Stark on 15/11/2024.
//
import SwiftUI

struct TextButton: View {
    var title: String
    var backgroundColor: Color = .blue
    var cornerRadius: CGFloat = 8

    var body: some View {
        Text(title)
            .foregroundColor(.white)
            .frame(minWidth: 150)
            .padding()
            .background(
                RoundedRectangle(cornerRadius: cornerRadius)
                    .fill(backgroundColor)
            )
            .frame(maxWidth: .infinity)
    }
}

#Preview {
    TextButton(title: "hello world")
}
