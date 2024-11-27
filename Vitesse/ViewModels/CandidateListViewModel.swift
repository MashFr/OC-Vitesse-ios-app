//
//  CandidateListViewModel.swift
//  Vitesse
//
//  Created by Tony Stark on 25/11/2024.
//

import Foundation
import Combine

class CandidateListViewModel: ObservableObject, CandidateListViewModelOutput, CandidateListViewModelInput {

    // MARK: - OUTPUT
    var output: CandidateListViewModelOutput { self }

    @Published private(set) var candidates: [Candidate] = sampleCandidates
    @Published private(set) var selectedCandidates: Set<UUID> = []
    @Published private(set) var searchText: String = ""
    @Published private(set) var showFavoritesOnly: Bool = false

    var filteredCandidates: [Candidate] {
        candidates.filter { candidate in
            let matchesFavorite = !showFavoritesOnly || candidate.isFavorite
            let matchesSearch = searchText.isEmpty || candidate.firstName.lowercased().contains(searchText.lowercased())
            return matchesFavorite && matchesSearch
        }
    }

    // MARK: - INPUT

    var input: CandidateListViewModelInput { self}

    func toggleFavoritesFilter() {
        showFavoritesOnly.toggle()
    }

    func updateSearchText(_ text: String) {
        searchText = text
    }

    func updateSelection(_ ids: Set<UUID>) {
        selectedCandidates = ids
    }

    func deleteSelectedCandidates() {
        candidates.removeAll { candidate in
            selectedCandidates.contains(candidate.id)
        }
        selectedCandidates.removeAll()
    }
}

protocol CandidateListViewModelOutput {
    var candidates: [Candidate] { get }
    var selectedCandidates: Set<UUID> { get }
    var searchText: String { get }
    var showFavoritesOnly: Bool { get }
    var filteredCandidates: [Candidate] { get }
}

protocol CandidateListViewModelInput {
    func toggleFavoritesFilter()
    func updateSearchText(_ text: String)
    func updateSelection(_ ids: Set<UUID>)
    func deleteSelectedCandidates()
}
