//
//  HomeView.swift
//  TechBrief
//
//  Created by Maria on 12.11.2025.
//

import SwiftUI

struct HomeView: View {
    @StateObject private var viewModel = HomeViewModel()
    
    var body: some View {
        NavigationStack {
            content
                .navigationTitle("TechBrief")
                .navigationBarTitleDisplayMode(.large)
                .toolbarBackground(.automatic, for: .navigationBar)
                .toolbarBackground(.visible, for: .navigationBar)
                .navigationDestination(for: ArticleViewData.self) { article in
                    ArticleDetailView(article: article)
                }
        }
        .task {
            if case .idle = viewModel.state {
                await viewModel.load()
            }
        }
    }
    
    
    @ViewBuilder
    private var content: some View {
        switch viewModel.state {
        case .idle, .loading:
            ProgressView("Fetching stories…")
                .frame(maxWidth: .infinity, maxHeight: .infinity)
            
        case .error(let message):
            VStack(spacing: 12) {
                Text("Couldn’t load articles")
                    .font(.title3).bold()
                Text(message)
                    .font(.subheadline)
                    .foregroundStyle(.secondary)
                
                Button("Retry") {
                    Task { await viewModel.retry() }
                }
            }
            .frame(maxWidth: .infinity, maxHeight: .infinity)
            
        case .loaded:
            if viewModel.articles.isEmpty {
                ContentUnavailableView(
                    "No articles yet",
                    systemImage: "newspaper",
                    description: Text("Pull to refresh or check your connection.")
                )
            } else {
                List(viewModel.articles) { article in
                    NavigationLink(value: article) {
                        ArticleRowView(article: article) {
                            viewModel.toggleSaved(for: article)
                        }
                    }
                }
                .listStyle(.insetGrouped)
                .refreshable {
                            await viewModel.load()
                        }
            }
        }
    }
}

#Preview { HomeView() }
