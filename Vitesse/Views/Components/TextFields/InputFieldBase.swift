//
//  InputFieldBase.swift
//  Vitesse
//
//  Created by Tony Stark on 15/11/2024.
//
import SwiftUI

struct InputFieldModifier: ViewModifier {
    func body(content: Content) -> some View {
        content
            .padding(14)
            .background(Color(.secondarySystemBackground))
            .cornerRadius(8)
    }
}

protocol InputField {
    var label: String { get }
    var placeholder: String { get }
    var text: Binding<String> { get set }
}
