//
//  CandidateListViewModel.swift
//  Vitesse
//
//  Created by Tony Stark on 25/11/2024.
//

import Foundation
import Combine

class CandidateListViewModel: ObservableObject, CandidateListViewModelOutput, CandidateListViewModelInput {

    // MARK: - Dependencies
    private let repository: CandidateRepository

    // MARK: - INIT
    init(repository: CandidateRepository = CandidateRepository()) {
        self.repository = repository
    }

    // MARK: - OUTPUT
    var output: CandidateListViewModelOutput { self }

    @Published private(set) var candidates: [Candidate] = []
    @Published private(set) var selectedCandidates: Set<UUID> = []
    @Published private(set) var searchText: String = ""
    @Published private(set) var showFavoritesOnly: Bool = false

    @Published private(set) var showErrorAlert: Bool = false
    @Published private(set) var errorAlertMsg: String?

    var filteredCandidates: [Candidate] {
        candidates.filter { candidate in
            let matchesFavorite = !showFavoritesOnly || candidate.isFavorite
            let matchesSearch = searchText.isEmpty || candidate.firstName.lowercased().contains(searchText.lowercased())
            return matchesFavorite && matchesSearch
        }
    }

    // MARK: - INPUT

    var input: CandidateListViewModelInput { self}

    // MARK: - Fetch Candidates
    func fetchCandidates() {
        self.candidates.removeAll()
        repository.fetchCandidates { result in
            DispatchQueue.main.async {
                switch result {
                case .success(let fetchedCandidates):
                    self.candidates = fetchedCandidates
                case .failure(let error):
                    self.showErrorAlert = true
                    self.errorAlertMsg = error.localizedDescription
                }
            }
        }
    }

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
        let selectedIds = Array(selectedCandidates) // Convertir le Set en tableau
        let group = DispatchGroup() // Gérer les suppressions simultanées
        var failedCandidates: [UUID] = [] // Garde une trace des suppressions échouées

        selectedIds.forEach { candidateId in
            group.enter()
            repository.deleteCandidate(candidateId: candidateId) { result in
                DispatchQueue.main.async {
                    switch result {
                    case .success:
                        // Supprimer localement le candidat de la liste s'il est supprimé avec succès
                        self.candidates.removeAll { $0.id == candidateId }
                    case .failure:
                        // Ajouter l'ID du candidat échoué à la liste des erreurs
                        failedCandidates.append(candidateId)
                    }
                    group.leave()
                }
            }
        }

        group.notify(queue: .main) {
            if failedCandidates.isEmpty {
                // Si toutes les suppressions réussissent
                self.fetchCandidates() // Rafraîchir la liste complète
            } else {
                // Si certaines suppressions échouent, afficher une alerte
                self.showErrorAlert = true
                self.errorAlertMsg = "\(failedCandidates.count) suppression(s) ont échoué. Veuillez réessayer."
            }
        }
    }

    func updateShowErrorAlert(_ show: Bool) {
        showErrorAlert = show
        if show == false {
            errorAlertMsg = nil
        }
    }
}

protocol CandidateListViewModelOutput {
    var candidates: [Candidate] { get }
    var selectedCandidates: Set<UUID> { get }
    var searchText: String { get }
    var showFavoritesOnly: Bool { get }
    var filteredCandidates: [Candidate] { get }
    var showErrorAlert: Bool { get }
    var errorAlertMsg: String? { get }
}

protocol CandidateListViewModelInput {
    func toggleFavoritesFilter()
    func updateSearchText(_ text: String)
    func updateSelection(_ ids: Set<UUID>)
    func updateShowErrorAlert(_ show: Bool)
    func deleteSelectedCandidates()
    func fetchCandidates()
}
