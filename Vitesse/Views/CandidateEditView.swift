//
//  CandidateEditView.swift
//  Vitesse
//
//  Created by Tony Stark on 19/11/2024.
//

import SwiftUI

struct CandidateEditView: View {
    @StateObject private var viewModel: CandidateEditViewModel

    init(candidate: Candidate) {
        _viewModel = StateObject(wrappedValue: CandidateEditViewModel(candidate: candidate))
    }

    @Environment(\.presentationMode) var presentationMode
    @Environment(\.horizontalSizeClass) private var sizeClass

    var body: some View {
        VStack(alignment: .leading, spacing: 30) {
            Text("\(viewModel.output.candidate.firstName) \(viewModel.output.candidate.lastName)")
                .font(.largeTitle)
                .bold()

            Form {
                // Phone Field
                VStack(alignment: .leading, spacing: 5) {
                    TextInputField(
                        label: "Phone",
                        placeholder: "",
                        text: Binding(
                            get: { viewModel.output.candidate.phone ?? "" },
                            set: { viewModel.input.updatePhone($0) }
                        )
                    )
                    .padding(.bottom, 4)

                    if let phoneError = viewModel.output.phoneError?.errorDescription {
                        Text(phoneError)
                            .font(.caption)
                            .foregroundColor(.red)
                    }
                }
                .padding(.bottom, 14)

                // Email Field
                VStack(alignment: .leading, spacing: 5) {
                    EmailInputField(
                        label: "Email",
                        placeholder: "",
                        text: Binding(
                            get: { viewModel.output.candidate.email },
                            set: { viewModel.input.updateEmail($0) }
                        )
                    )
                    .padding(.bottom, 4)

                    if let emailError = viewModel.output.emailError?.errorDescription {
                        Text(emailError)
                            .font(.caption)
                            .foregroundColor(.red)
                    }
                }
                .padding(.bottom, 14)

                // LinkedIn URL Field
                VStack(alignment: .leading, spacing: 5) {
                    TextInputField(
                        label: "LinkedIn",
                        placeholder: "",
                        text: Binding(
                            get: { viewModel.output.candidate.linkedinURL?.absoluteString ?? "" },
                            set: { viewModel.input.updateLinkedInURL($0) }
                        )
                    )
                    .padding(.bottom, 4)

                    if let linkedInURLError = viewModel.output.linkedInURLError?.errorDescription {
                        Text(linkedInURLError)
                            .font(.caption)
                            .foregroundColor(.red)
                    }
                }
                .padding(.bottom, 14)

                // Note Field
                TextEditorField(
                    label: "Note",
                    placeholder: "",
                    text: Binding(
                        get: { viewModel.output.candidate.note ?? "" },
                        set: { viewModel.input.updateNote($0) }
                    )
                )
                .padding(.bottom, 14)
            }
            .formStyle(.columns)
            .safeAreaPadding(.horizontal, sizeClass == .regular ? 200 : 0)
        }
        .toolbar {
            ToolbarItemGroup(placement: .navigationBarTrailing) {
                Button {
                    viewModel.input.saveCandidate()
                } label: {
                    if viewModel.output.isSaving {
                        ProgressView()
                    } else {
                        Text("Done")
                    }
                }
            }
        }
        .padding()
        .alert(
            "Successful modification",
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
        .alert(isPresented: Binding(
            get: { viewModel.output.showErrorAlert },
            set: { isAlertShown in
                viewModel.input.updateShowErrorAlert(isAlertShown)
            }
        )) {
            Alert(
                title: Text("Error"),
                message: Text(viewModel.output.errorMessage ?? ""),
                dismissButton: .default(Text("OK"))
            )
        }
    }
}

#Preview {
    NavigationStack {
        CandidateEditView(candidate: sampleCandidates.first!)
    }
}
