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
                .searchable(
                    text: $viewModel.searchText,
                    placement: .navigationBarDrawer(displayMode: .automatic),
                    prompt: "Search by title or source"
                )
                .toolbar {
                    ToolbarItem(placement: .topBarTrailing) {
                        Picker("Source", selection: $viewModel.sourceFilter) {
                            ForEach(HomeViewModel.SourceFilter.allCases) { filter in
                                Text(filter.rawValue).tag(filter)
                            }
                        }
                        .pickerStyle(.segmented)
                        .frame(maxWidth: 260)
                    }
                }
                .navigationDestination(for: ArticleViewData.self) { article in
                    ArticleDetailView(article: article)
                }
                .navigationBarTitleDisplayMode(.large)
                .toolbarBackground(.automatic, for: .navigationBar)
                .toolbarBackground(.visible, for: .navigationBar)
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
            let listArticles = viewModel.filteredArticles
            
            if listArticles.isEmpty {
                ContentUnavailableView(
                    "No articles found",
                    systemImage: "magnifyingglass",
                    description: Text("Try a different search or source.")
                )
            } else {
                List(listArticles) { article in
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
