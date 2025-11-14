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
    
    func load() async {
        state = .loading
        
        do {
            let hnArticles = try await service.fetchTopArticles()
            self.articles = hnArticles.map { $0.toViewData() }
            state = .loaded
        } catch {
            state = .error(String(describing: error))
        }
    }
    
    func retry() async {
        await load()
    }
}
