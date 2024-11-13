//
//  LoginView.swift
//  Vitesse
//
//  Created by Tony Stark on 13/11/2024.
//

import SwiftUI

struct LoginView: View {
    @State private var email = ""
    @State private var password = ""

    var body: some View {
        NavigationStack {

            VStack {
                Text("Login")
                    .font(.largeTitle)
                    .fontWeight(.bold)

                TextField("Email", text: $email)
                    .padding()
                    .background(Color(.secondarySystemBackground))
                    .cornerRadius(8)
                    .keyboardType(.emailAddress)
                    .autocapitalization(.none)

                SecureField("Password", text: $password)
                    .padding()
                    .background(Color(.secondarySystemBackground))
                    .cornerRadius(8)

                Button(action: handleSignIn) {
                    Text("Sign In")
                        .foregroundColor(.white)
                        .frame(maxWidth: .infinity)
                        .padding()
                        .background(Color.blue)
                        .cornerRadius(8)
                }

                NavigationLink(
                    destination: RegisterView(),
                    label: {
                        Text("Register")
                            .font(.headline)
                            .foregroundColor(.white)
                            .padding()
                            .background(.primary)
                            .cornerRadius(8)
                    }
                )

            }
            .padding()
        }
    }

    // Validation et gestion de l'inscription
    func handleSignIn() {
        // Inscription réussie (à connecter avec une base de données ou un backend)
        print("connexion réussie !")
    }

}

#Preview {
    LoginView()
}
