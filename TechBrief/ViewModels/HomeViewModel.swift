//
//  HomeViewModel.swift
//  TechBrief
//
//  Created by Maria on 12.11.2025.
//

import Foundation

final class HomeViewModel: ObservableObject {
    
    enum State {
        case idle
        case loading
        case loaded
        case error(String)
    }
    
    @Published private(set) var articles: [ArticleViewData] = []
    @Published private(set) var state: State = .idle
    
    private let service = HNService()
    private let savedStore = SavedArticlesStore()
    
    @MainActor
    func load() async {
        state = .loading
        do {
            let hnArticles = try await service.fetchTopArticles()
            let mapped = hnArticles.map { $0.toViewData() }
            
            let withSaved = mapped.map { article -> ArticleViewData in
                var copy = article
                copy.isSaved = savedStore.isSaved(article.id)
                return copy
            }
            
            self.articles = withSaved
            state = .loaded
            
        } catch {
            state = .error(error.localizedDescription)
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
}
