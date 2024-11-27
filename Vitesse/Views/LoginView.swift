//
//  LoginView.swift
//  Vitesse
//
//  Created by Tony Stark on 13/11/2024.
//

import SwiftUI

struct LoginView: View {
    @StateObject private var viewModel = LoginViewModel()

    @Environment(\.horizontalSizeClass) private var sizeClass

    var body: some View {
        NavigationStack {
            VStack(alignment: .center) {
                TopView(title: "Login", details: "Welcome to Vitesse app")

                Spacer()

                Form {
                    EmailInputField(label: "Email/Username", placeholder: "", text: Binding(
                        get: {
                            viewModel.output.email
                        }, set: { email in
                            viewModel.input.updateEmail(email)
                        })
                    )
                    .padding(.bottom, 14)

                    SecureInputField(label: "Password", placeholder: "", text: Binding(
                        get: {
                            viewModel.output.password
                        }, set: { password in
                            viewModel.input.updatePassword(password)
                        })
                    )

                    if let errorMessage = viewModel.output.errorMessage {
                        Text(errorMessage)
                            .foregroundStyle(.red)
                            .font(.caption)
                            .padding(.bottom, 10)
                    }

                    Text("Forgot password?")
                        .font(.caption)
                        .padding(.bottom, 20)

                    Button {
                        Task {
                            await viewModel.input.login()
                        }
                    } label: {
                        if viewModel.output.isLoading {
                            ProgressButton()
                        } else {
                            TextButton(title: "Sign In")
                        }
                    }.padding(.bottom, 14)
                }
                .formStyle(.columns)
                .safeAreaPadding(.horizontal, sizeClass == .regular ? 200 : 30)

                NavigationLink {
                    RegisterView()
                } label: {
                    TextButton(title: "Register")
                }

                Spacer()
            }
            .navigationDestination(isPresented: Binding(
                get: { viewModel.output.isLoginSuccessful },
                set: { _ in } // no need for setter here
            )) {
                CandidateListView()
            }
        }
    }
}

#Preview {
    LoginView()
}
