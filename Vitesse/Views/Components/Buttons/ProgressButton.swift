//
//  ProgressButton.swift
//  Vitesse
//
//  Created by Tony Stark on 15/11/2024.
//
import SwiftUI

struct ProgressButton: View {
    var backgroundColor: Color = .blue
    var cornerRadius: CGFloat = 8

    var body: some View {
        ProgressView()
            .foregroundColor(.white)
            .frame(minWidth: 150)
            .padding()
            .background(
                RoundedRectangle(cornerRadius: cornerRadius)
                    .fill(backgroundColor)
            )
            .frame(maxWidth: .infinity)
            .progressViewStyle(CircularProgressViewStyle(tint: Color.white))
    }
}

#Preview {
    ProgressButton()
}
