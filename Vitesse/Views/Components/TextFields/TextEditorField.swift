//
//  TextEditorField.swift
//  Vitesse
//
//  Created by Tony Stark on 15/11/2024.
//
import SwiftUI

struct TextEditorField: View, InputField {
    var label: String
    var placeholder: String
    var text: Binding<String>

    var keyboardType: UIKeyboardType = .default

    var body: some View {
        VStack(alignment: .leading, spacing: 5) {
            Text(label)
                .fontWeight(.bold)
            TextEditor(text: text)
                .modifier(InputFieldModifier())
                .foregroundColor(Color.gray)
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
