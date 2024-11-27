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
                TextInputField(label: "Phone", placeholder: "", text: Binding(
                    get: { viewModel.output.candidate.phone ?? ""},
                    set: { viewModel.input.updatePhone($0) }
                ))
                .padding(.bottom, 14)

                EmailInputField(label: "Email", placeholder: "", text: Binding(
                    get: { viewModel.output.candidate.email },
                    set: { viewModel.input.updateEmail($0) }
                ))
                .padding(.bottom, 14)

                TextInputField(label: "LinkedIn", placeholder: "", text: Binding(
                    get: { viewModel.output.candidate.linkedinURL?.absoluteString ?? "" },
                    set: { viewModel.input.updateLinkedInURL($0) }
                ))
                .padding(.bottom, 14)

                TextEditorField(label: "Note", placeholder: "", text: Binding(
                    get: { viewModel.output.candidate.note ?? "" },
                    set: { viewModel.input.updateNote($0) }
                ))
                .padding(.bottom, 14)

            }
            .formStyle(.columns)
            .safeAreaPadding(.horizontal, sizeClass == .regular ? 200 : 0)

        }
        .toolbar {
            ToolbarItemGroup(placement: .navigationBarTrailing) {
                Button {
                    Task {
                        await viewModel.input.saveCandidate()
                        if viewModel.output.errorMessage == nil {
                            presentationMode.wrappedValue.dismiss()
                        }
                    }
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
