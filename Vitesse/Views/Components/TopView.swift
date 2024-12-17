//
//  TopView.swift
//  Vitesse
//
//  Created by Tony Stark on 15/11/2024.
//
import SwiftUI

struct TopView: View {
    var title: String
    var details: String

    var body: some View {
        VStack(alignment: .center, spacing: 14) {
            Text(title)
                .font(.title.bold())
            Text(details)
                .font(.subheadline)
                .foregroundStyle(.secondary)
        }
        .padding(.top, 10)
    }
}
