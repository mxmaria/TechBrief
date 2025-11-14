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
                    VStack(alignment: .leading, spacing: 4) {
                        Text(article.title)
                            .font(.headline)
                            .lineLimit(2)
                        
                        HStack(spacing: 4) {
                            Text(article.source)
                            Text("•")
                            Text(article.timeAgo)
                        }
                        .font(.caption)
                        .foregroundStyle(.secondary)
                    }
                    .padding(.vertical, 4)
                }
                .listStyle(.plain)
            }
        }
    }
}

#Preview { HomeView() }
