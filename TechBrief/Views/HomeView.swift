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
            VStack(spacing: 16) {
                ContentUnavailableView(
                    viewModel.isOffline ? "You're offline" : "Couldn't load articles",
                    systemImage: viewModel.isOffline ? "wifi.slash" : "exclamationmark.triangle",
                    description: Text(message)
                )
                
                Button("Try again") {
                    Task {
                        await viewModel.load()
                    }
                }
                .buttonStyle(.borderedProminent)
                
                if viewModel.isOffline {
                    Text("You can still read your saved articles in the Saved tab.")
                        .font(.footnote)
                        .foregroundStyle(.secondary)
                        .multilineTextAlignment(.center)
                        .padding(.horizontal)
                }
            }
            .frame(maxWidth: .infinity, maxHeight: .infinity)
            
        case .loaded:
            let listArticles = viewModel.filteredArticles
            
            if listArticles.isEmpty {
                ContentUnavailableView(
                    viewModel.isOffline ? "No cached articles" : "No articles found",
                    systemImage: viewModel.isOffline ? "wifi.slash" : "magnifyingglass",
                    description: viewModel.isOffline
                    ? Text("Try going online to fetch new articles.")
                    : Text("Try a different search or source.")
                )
            } else {
                VStack(spacing: 0) {
                    if viewModel.isOffline {
                        OfflineBannerView()
                            .padding(.bottom, 4)
                    }
                    
                    List(listArticles) { article in
                        NavigationLink(value: article) {
                            ArticleRowView(
                                article: article,
                                onToggleSave: { viewModel.toggleSaved(for: article) }
                            )
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
}

#Preview { HomeView() }
