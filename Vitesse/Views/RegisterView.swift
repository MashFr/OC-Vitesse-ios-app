//
//  RegisterView.swift
//  Vitesse
//
//  Created by Tony Stark on 13/11/2024.
//

import SwiftUI

struct RegisterView: View {
    @Environment(\.presentationMode) var presentationMode
    @Environment(\.horizontalSizeClass) private var sizeClass
    @State private var firstName: String = ""
    @State private var lastName: String = ""
    @State private var emailAddress: String = ""
    @State private var password: String = ""
    @State private var confirmPassword: String = ""
    @State private var showAlert: Bool = false
    @State private var alertMessage: String = ""

    var body: some View {
        VStack(alignment: .center ) {
            TopView(title: "Register", details: "Register to Vitesse app")
            Spacer()
            Form {
                // MARK: User infos
                Section {
                    VStack(alignment: .leading, spacing: 5) {
                        Text("First Name")
                            .fontWeight(.bold)
                        TextField("Click here to enter", text: $firstName)
                            .padding(14)
                            .background(Color(.secondarySystemBackground))
                            .cornerRadius(8)
                    }.padding(.bottom, 14)

                    VStack(alignment: .leading, spacing: 5) {
                        Text("Last Name")
                            .fontWeight(.bold)
                        TextField("", text: $lastName)
                            .padding(14)
                            .background(Color(.secondarySystemBackground))
                            .cornerRadius(8)
                    }.padding(.bottom, 14)

                    VStack(alignment: .leading, spacing: 5) {
                        Text("Email")
                            .fontWeight(.bold)
                        TextField("", text: $emailAddress)
                            .padding(14)
                            .background(Color(.secondarySystemBackground))
                            .cornerRadius(8)
                            .keyboardType(.emailAddress)
                            .autocapitalization(.none)
                            .textContentType(.emailAddress)
                    }.padding(.bottom, 14)
                }

                // MARK: Password
                Section {
                    VStack(alignment: .leading, spacing: 5) {
                        Text("Mot de passe")
                            .fontWeight(.bold)
                        SecureField("", text: $password)
                            .padding(14)
                            .background(Color(.secondarySystemBackground))
                            .cornerRadius(8)
                            .textContentType(.newPassword)
                    }.padding(.bottom, 14)

                    VStack(alignment: .leading, spacing: 5) {
                        Text("Confirmer le mot de passe")
                            .fontWeight(.bold)
                        SecureField("", text: $confirmPassword)
                            .padding(14)
                            .background(Color(.secondarySystemBackground))
                            .cornerRadius(8)
                            .textContentType(.newPassword)
                    }.padding(.bottom, 14)
                }
                // MARK: Submit
                Section {
                    Button(action: handleRegister) {
                        Text("Create")
                            .frame(minWidth: 150)
                            .foregroundColor(.white)
                            .padding()
                            .background(Color.blue)
                            .cornerRadius(8)
                            .frame(maxWidth: .infinity)
                    }
                }
            }
            .formStyle(.columns)
            .safeAreaPadding(.horizontal, sizeClass == .regular ? 200 : 30)

            Spacer()
        }
    }
    // Validation et gestion de l'inscription
    func handleRegister() {
        // Inscription réussie (à connecter avec une base de données ou un backend)
        print("Inscription réussie !")
        presentationMode.wrappedValue.dismiss() // Retourner à la vue de connexion
    }
}

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
        }.padding(.top, 10)
    }
}

#Preview {
    RegisterView()
}
