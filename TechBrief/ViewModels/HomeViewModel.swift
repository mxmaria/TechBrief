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
    
    private let hnService = HNService()
    private let devToService = DevToService()
    private let savedStore = SavedArticlesStore()
    
    @MainActor
    func load() async {
        state = .loading
        do {
            async let hnTask = hnService.fetchTopArticles()
            async let devTask = devToService.fetchLatestArticles()
            
            let hnArticles = try await hnTask
            let devArticles = try await devTask
            
            let hnViewData = hnArticles.map { $0.toViewData() }
            let devViewData = devArticles.map { ArticleViewData(from: $0) }
            
            let unified = hnViewData + devViewData
            
            let withSaved = unified.map { article -> ArticleViewData in
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
