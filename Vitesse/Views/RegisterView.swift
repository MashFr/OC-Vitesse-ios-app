//
//  RegisterView.swift
//  Vitesse
//
//  Created by Tony Stark on 13/11/2024.
//

import SwiftUI

struct RegisterView: View {
    @StateObject private var viewModel = RegisterViewModel()
    @Environment(\.presentationMode) var presentationMode
    @Environment(\.horizontalSizeClass) private var sizeClass

    var body: some View {
        VStack(alignment: .center) {
            TopView(title: "Register", details: "Register to Vitesse app")

            Spacer()

            Form {
                Section {
                    TextInputField(
                        label: "First Name",
                        placeholder: "",
                        text: Binding(
                            get: { viewModel.output.firstName },
                            set: { viewModel.input.updateFirstName($0) }
                        )
                    ).padding(.top, 14)
                    if let error = viewModel.output.firstNameError {
                        Text(error.localizedDescription).foregroundColor(.red).font(.caption)
                    }

                    TextInputField(
                        label: "Last Name",
                        placeholder: "",
                        text: Binding(
                            get: { viewModel.output.lastName },
                            set: { viewModel.input.updateLastName($0) }
                        )
                    ).padding(.top, 14)
                    if let error = viewModel.output.lastNameError {
                        Text(error.localizedDescription).foregroundColor(.red).font(.caption)
                    }

                    EmailInputField(
                        label: "Email",
                        placeholder: "",
                        text: Binding(
                            get: { viewModel.output.emailAddress },
                            set: { viewModel.input.updateEmailAddress($0) }
                        )
                    ).padding(.top, 14)
                    if let error = viewModel.output.emailError {
                        Text(error.localizedDescription).foregroundColor(.red).font(.caption)
                    }
                }

                Section {
                    SecureInputField(
                        label: "Password",
                        placeholder: "",
                        text: Binding(
                            get: { viewModel.output.password },
                            set: { viewModel.input.updatePassword($0) }
                        )
                    ).padding(.top, 14)
                    if let error = viewModel.output.passwordError {
                        Text(error.localizedDescription).foregroundColor(.red).font(.caption)
                    }

                    SecureInputField(
                        label: "Confirm Password",
                        placeholder: "",
                        text: Binding(
                            get: { viewModel.output.confirmPassword },
                            set: { viewModel.input.updateConfirmPassword($0) }
                        )
                    ).padding(.top, 14)
                    if let error = viewModel.output.confirmPasswordError {
                        Text(error.localizedDescription).foregroundColor(.red).font(.caption)
                    }
                }

                Button {
                    viewModel.input.register()
                } label: {
                    if viewModel.output.isLoading {
                        ProgressButton()
                    } else {
                        TextButton(title: "Create")
                    }
                }.padding(.top, 14)
            }
            .formStyle(.columns)
            .safeAreaPadding(.horizontal, sizeClass == .regular ? 200 : 30)

            Spacer()
        }
        .alert(
            "Inscription réussie",
            isPresented: Binding(
                get: {
                    viewModel.output.showSuccessAlert
                }, set: { showSuccessAlert in
                    viewModel.input.updateShowSuccessAlert(showSuccessAlert)
                }),
            actions: {
                Button("OK") {
                    presentationMode.wrappedValue.dismiss()
                }
            }
        )
        .alert(
            "Inscription échoué",
            isPresented: Binding(
                get: {
                    viewModel.output.showErrorAlert
                }, set: { showErrorAlert in
                    viewModel.input.updateShowErrorAlert(showErrorAlert)
                }
            ),
            actions: {
                Button("OK") {}
            },
            message: {
                Text("Veuillez réessayer.")

            }
        )
    }
}

#Preview {
    RegisterView()
}
