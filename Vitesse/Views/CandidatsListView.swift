//
//  CandidateListView.swift
//  Vitesse
//
//  Created by Tony Stark on 13/11/2024.
//

import SwiftUI

struct CandidateListView: View {
    @StateObject private var viewModel = CandidateListViewModel()

    @Environment(\.editMode) private var editMode

    var body: some View {
        NavigationStack {
            List(selection: editMode?.wrappedValue.isEditing == true ? Binding(get: {
                viewModel.output.selectedCandidates
            }, set: { selectedCandidates in
                viewModel.input.updateSelection(selectedCandidates)
            }) : nil) {
                ForEach(viewModel.output.filteredCandidates) { candidate in
                    CandidateRow(candidate: candidate)
                        .listRowSeparator(.hidden)
                        .listRowInsets(.init(top: 0, leading: 20, bottom: 0, trailing: 20))
                }
            }
            .listRowSpacing(20)
            .navigationTitle("Candidats")
            .toolbar {
                ToolbarItemGroup(placement: .navigationBarLeading) {
                    EditButton()
                }
                ToolbarItemGroup(placement: .navigationBarTrailing) {
                    if !viewModel.output.selectedCandidates.isEmpty {
                        Button("Delete", systemImage: "trash") {
                            viewModel.input.deleteSelectedCandidates()
                        }
                    } else {
                        Button {
                            viewModel.input.toggleFavoritesFilter()
                        } label: {
                            Image(systemName: viewModel.output.showFavoritesOnly ? "star.fill" : "star")
                                .foregroundStyle(viewModel.output.showFavoritesOnly ? .yellow : .gray)
                        }
                    }
                }
            }
            .searchable(
                text: Binding(get: {
                    viewModel.output.searchText
                }, set: { text in
                    viewModel.input.updateSearchText(text)
                }),
                placement: .navigationBarDrawer(displayMode: .always),
                prompt: "Search candidates"
            )
            .scrollContentBackground(.hidden)
            .listStyle(.plain)
        }
        .alert(isPresented: Binding(get: {
            viewModel.output.showErrorAlert
        }, set: { showErrorAlert in
            viewModel.input.updateShowErrorAlert(showErrorAlert)
        })) {
            var errorMsg = "Veuillez réessayer."
            if let error = viewModel.output.errorAlertMsg {
                errorMsg = error
            }

            return Alert(
                title: Text("An error occured"),
                message: Text(
                    errorMsg
                )
            )
        }
        .onAppear {
            viewModel.input.fetchCandidates()
        }
    }
}

#Preview {
    CandidateListView()
}
