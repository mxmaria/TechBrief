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
                Text("No articles")
                    .frame(maxWidth: .infinity, maxHeight: .infinity)
            } else {
                List(viewModel.articles) { article in
                    NavigationLink(value: article) {
                        ArticleRowView(article: article) {
                            viewModel.toggleSaved(for: article)
                        }
                    }
                }
                .listStyle(.insetGrouped)
            }
        }
    }
}

#Preview { HomeView() }
