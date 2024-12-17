//
//  CandidateDetailView.swift
//  Vitesse
//
//  Created by Tony Stark on 18/11/2024.
//
import SwiftUI

struct CandidateDetailView: View {
    @StateObject var viewModel: CandidateDetailViewModel

    init(candidate: Candidate) {
        _viewModel = StateObject(wrappedValue: CandidateDetailViewModel(candidate: candidate))
    }

    var body: some View {
        VStack(alignment: .leading, spacing: 30) {
            HStack {
                Text("\(viewModel.output.candidate.firstName) \(viewModel.output.candidate.lastName)")
                    .font(.largeTitle)
                    .bold()
                Spacer()
                if UserDefaults.standard.bool(forKey: "is_admin") {
                    Button {
                        viewModel.input.markCandidateAsFavorite()
                    } label: {
                        Image(systemName: viewModel.output.candidate.isFavorite ? "star.fill" : "star")
                            .foregroundStyle(viewModel.output.candidate.isFavorite ? .yellow : .gray)
                    }
                }
            }

            HStack {
                Image(systemName: "phone")
                    .foregroundStyle(.blue)
                Text("Phone:")
                if let phone = viewModel.output.candidate.phone {
                    Link(phone, destination: URL(string: phone)!)

                } else {
                    Text("No Phone number available")
                        .foregroundStyle(.gray)
                }
            }

            HStack {
                Image(systemName: "envelope")
                    .foregroundStyle(.blue)
                Text("Email:")
                Link(viewModel.output.candidate.email, destination: URL(string: viewModel.output.candidate.email)!)
            }

            HStack {
                Image(systemName: "link")
                    .foregroundStyle(.blue)
                Text("LinkedIn:")
                if let url = viewModel.output.candidate.linkedinURL {
                    LinkButton(
                        title: "Go on LinkedIn",
                        url: url,
                        backgroundColor: .blue
                    )
                } else {
                    Text("No LinkedIn profile")
                        .foregroundStyle(.gray)
                }
            }

            VStack(alignment: .leading, spacing: 10) {
                Text("Note")
                    .font(.headline)

                ScrollView {
                    if let note = viewModel.output.candidate.note {
                        Text(note)
                    } else {
                        Text("No note available.")
                    }
                }
                .frame(maxWidth: .infinity, alignment: .leading)
                .padding()
                .background(alignment: .center) {
                    RoundedRectangle(cornerRadius: 10)
                        .stroke(Color.gray, lineWidth: 3)
                }
                .frame(maxHeight: 400)
            }

            Spacer()
        }
        .padding()
        .toolbar {
            ToolbarItemGroup(placement: .navigationBarTrailing) {
                NavigationLink(destination: CandidateEditView(candidate: viewModel.output.candidate)) {
                    Text("Edit")
                }
            }
        }
        .alert(
            "An error occured",
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
                Text("\(viewModel.output.errorAlertMsg ?? "Please retry")")
            }
        )
        .onAppear {
            viewModel.input.fetchCandidate()
        }
    }
}

#Preview {
    NavigationStack {
        CandidateDetailView(candidate: sampleCandidates.first!)
    }
}
