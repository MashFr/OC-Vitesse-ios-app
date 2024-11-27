//
//  LinkButton.swift
//  Vitesse
//
//  Created by Tony Stark on 19/11/2024.
//
import SwiftUI

struct LinkButton: View {
    var title: String
    var url: URL
    var backgroundColor: Color = .blue
    var cornerRadius: CGFloat = 8

    var body: some View {
        Link(destination: url) {
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
}

#Preview {
    LinkButton(
        title: "Swift.org",
        url: URL(string: "https://www.swift.org")!,
        backgroundColor: .blue
    )
}
