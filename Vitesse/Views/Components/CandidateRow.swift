//
//  CandidateRow.swift
//  Vitesse
//
//  Created by Tony Stark on 19/11/2024.
//

import SwiftUI

struct CandidateRow: View {
    let candidate: Candidate

    var body: some View {
        NavigationLink {
            CandidateDetailView(candidate: candidate)
        } label: {
            HStack {
                VStack(alignment: .leading) {
                    Text("\(candidate.firstName) \(candidate.lastName)")
                        .font(.headline)
                }

                Spacer()

                if candidate.isFavorite {
                    Image(systemName: "star.fill")
                        .foregroundStyle(.yellow)
                } else {
                    Image(systemName: "star")
                        .foregroundStyle(.gray)
                }
            }
        }
        .padding()
        .overlay(
            RoundedRectangle(cornerRadius: 8)
                .stroke(Color.blue, lineWidth: 3)
        )
    }
}

#Preview {
    NavigationStack {
        CandidateRow(candidate: sampleCandidates.first!)
        CandidateRow(candidate: sampleCandidates.last!)
    }
}
