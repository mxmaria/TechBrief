//
//  ArticleCache.swift
//  TechBrief
//
//  Created by Maria on 27.11.2025.
//

import Foundation

struct ArticleCache {
    private let fileURL: URL = {
        let base = FileManager.default.urls(for: .cachesDirectory, in: .userDomainMask).first!
        return base.appendingPathComponent("articles_cache.json")
    }()

    func load() -> [ArticleViewData]? {
        do {
            let data = try Data(contentsOf: fileURL)
            let decoder = JSONDecoder()
            return try decoder.decode([ArticleViewData].self, from: data)
        } catch {
            print("Cache load failed:", error)
            return nil
        }
    }

    func save(_ articles: [ArticleViewData]) {
        do {
            let encoder = JSONEncoder()
            let data = try encoder.encode(articles)
            try data.write(to: fileURL, options: .atomic)
        } catch {
            print("Cache save failed:", error)
        }
    }
}
