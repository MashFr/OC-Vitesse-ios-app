//
//  TextInputField.swift
//  Vitesse
//
//  Created by Tony Stark on 15/11/2024.
//
import SwiftUI

struct TextInputField: View, InputField {
    var label: String
    var placeholder: String
    var text: Binding<String>

    var keyboardType: UIKeyboardType = .default

    var body: some View {
        VStack(alignment: .leading, spacing: 5) {
            Text(label)
                .fontWeight(.bold)
            TextField(placeholder, text: text)
                .modifier(InputFieldModifier())
        }
    }
}

#Preview {
    TextInputField(
        label: "Name",
        placeholder: "Enter your name",
        text: .constant("")
    )
}
