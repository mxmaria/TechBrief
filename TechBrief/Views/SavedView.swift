//
//  SavedView.swift
//  TechBrief
//
//  Created by Maria on 18.11.2025.
//

import SwiftUI

struct SavedView: View {
    @StateObject private var viewModel = HomeViewModel()

    var body: some View {
        NavigationStack {
            List(viewModel.articles.filter { $0.isSaved }) { article in
                NavigationLink(value: article) {
                    ArticleRowView(article: article) {
                        viewModel.toggleSaved(for: article)
                    }
                }
            }
            .navigationTitle("Saved")
        }
        .task {
            await viewModel.load()
        }
    }
}
