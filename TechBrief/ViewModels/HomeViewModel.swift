//
//  HomeViewModel.swift
//  TechBrief
//
//  Created by Maria on 12.11.2025.
//

import Foundation

@MainActor
final class HomeViewModel: ObservableObject {
    
    enum State {
        case idle
        case loading
        case loaded
        case error(String)
    }
    
    enum SourceFilter: String, CaseIterable, Identifiable {
        case all = "All"
        case hackerNews = "Hacker News"
        case devTo = "Dev.to"
        
        var id: String { rawValue }
    }
    
    @Published private(set) var articles: [ArticleViewData] = []
    @Published private(set) var state: State = .idle
    
    @Published var searchText: String = ""
    @Published var sourceFilter: SourceFilter = .all
    
    @Published private(set) var isOffline: Bool = false
    
    private let hnService = HNService()
    private let devToService = DevToService()
    private let savedStore = SavedArticlesStore()
    private let cache = ArticleCache()
    
    @MainActor
    func load() async {
        isOffline = false
        
        if articles.isEmpty, let cached = cache.load() {
            let withSaved = applySavedState(to: cached)
            articles = withSaved
            state = .loaded
        } else if articles.isEmpty {
            state = .loading
        }
        
        do {
            async let hnTask = hnService.fetchTopArticles()
            async let devTask = devToService.fetchLatestArticles()
            
            let hnArticles = try await hnTask
            let devArticles = try await devTask
            
            let hnViewData = hnArticles.map { $0.toViewData() }
            let devViewData = devArticles.map { ArticleViewData(from: $0) }
            
            let unified = hnViewData + devViewData
            cache.save(unified)
            
            let withSaved = applySavedState(to: unified)
            
            self.articles = withSaved
            state = .loaded
            isOffline = false
        } catch {
            if isNetworkError(error) {
                isOffline = true
            }
            
            if articles.isEmpty {
                state = .error(
                    isOffline
                    ? "Looks like you're offline. Check your connection and try again."
                    : "Something went wrong while loading articles."
                )
            }
        }
    }
    
    @MainActor
    func retry() async {
        await load()
    }
    
    @MainActor
    func toggleSaved(for article: ArticleViewData) {
        savedStore.toggle(id: article.id)
        
        if let idx = articles.firstIndex(where: { $0.id == article.id }) {
            articles[idx].isSaved.toggle()
        }
    }
    
    var filteredArticles: [ArticleViewData] {
        var result = articles
        
        // source filter
        switch sourceFilter {
        case .all:
            break
        case .hackerNews:
            result = result.filter { $0.source == "Hacker News" }
        case .devTo:
            result = result.filter { $0.source == "Dev.to" }
        }
        
        // search filter (title or source)
        let query = searchText.trimmingCharacters(in: .whitespacesAndNewlines).lowercased()
        if !query.isEmpty {
            result = result.filter {
                $0.title.lowercased().contains(query) ||
                $0.source.lowercased().contains(query)
            }
        }
        
        return result
    }
    
    private func applySavedState(to articles: [ArticleViewData]) -> [ArticleViewData] {
        articles.map { article in
            var copy = article
            copy.isSaved = savedStore.isSaved(article.id)
            return copy
        }
    }
    
    private func isNetworkError(_ error: Error) -> Bool {
        if let apiError = error as? APIError {
            if case let .network(innerError) = apiError {
                return isNetworkError(innerError)
            } else {
                return false
            }
        }

        guard let urlError = error as? URLError else { return false }

        switch urlError.code {
        case .notConnectedToInternet,
             .timedOut,
             .cannotConnectToHost,
             .cannotFindHost,
             .networkConnectionLost,
             .dnsLookupFailed:
            return true
        default:
            return false
        }
    }
}
