//
//  EmailInputField.swift
//  Vitesse
//
//  Created by Tony Stark on 15/11/2024.
//
import SwiftUI

struct EmailInputField: View, InputField {
    var label: String
    var placeholder: String
    var text: Binding<String>

    var body: some View {
        VStack(alignment: .leading, spacing: 5) {
            Text(label)
                .fontWeight(.bold)
            TextField(placeholder, text: text)
                .modifier(InputFieldModifier())
                .keyboardType(.emailAddress)
                .textInputAutocapitalization(.never)
                .textContentType(.emailAddress)
        }
    }
}

#Preview {
    EmailInputField(
        label: "Email",
        placeholder: "Enter your email",
        text: .constant("")
    )
}
