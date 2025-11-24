//
//  DevToService.swift
//  TechBrief
//
//  Created by Maria on 24.11.2025.
//

import Foundation

struct DevToService {
    private let client = HTTPClient()

    func fetchLatestArticles() async throws -> [DevToArticle] {
        let url = URL(string: "https://dev.to/api/articles?per_page=30")!
        return try await client.get(from: url)
    }
}
