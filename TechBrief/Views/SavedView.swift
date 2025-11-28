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
            content
                .navigationTitle("Saved")
                .navigationBarTitleDisplayMode(.large)
                .navigationDestination(for: ArticleViewData.self) { article in
                    ArticleDetailView(article: article)
                }
        }
        .task {
            await viewModel.load()
        }
    }

    @ViewBuilder
    private var content: some View {
        let saved = viewModel.articles.filter { $0.isSaved }

        if saved.isEmpty {
            ContentUnavailableView(
                "No saved articles",
                systemImage: "star",
                description: Text("Tap the star on any article to save it for later.")
            )
        } else {
            VStack(spacing: 0) {
                if viewModel.isOffline {
                    OfflineBannerView()
                        .padding(.vertical, 4)
                }

                List(saved) { article in
                    NavigationLink(value: article) {
                        ArticleRowView(
                            article: article,
                            onToggleSave: {
                                viewModel.toggleSaved(for: article)
                            }
                        )
                    }
                }
                .listStyle(.insetGrouped)
            }
        }
    }
}
