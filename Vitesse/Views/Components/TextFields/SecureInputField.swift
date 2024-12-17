//
//  SecureInputField.swift
//  Vitesse
//
//  Created by Tony Stark on 15/11/2024.
//
import SwiftUI

struct SecureInputField: View, InputField {
    var label: String
    var placeholder: String
    var text: Binding<String>

    var body: some View {
        VStack(alignment: .leading, spacing: 5) {
            Text(label)
                .fontWeight(.bold)
            SecureField(placeholder, text: text)
                .modifier(InputFieldModifier())
                .textContentType(.newPassword)
        }
    }
}

#Preview {
    SecureInputField(
        label: "Password",
        placeholder: "Enter your password",
        text: .constant("MyPasswordIsNice")
    )
}
