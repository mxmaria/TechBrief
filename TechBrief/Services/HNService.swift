//
//  HNService.swift
//  TechBrief
//
//  Created by Maria on 14.11.2025.
//

import Foundation

struct HNService {
    private let client = HTTPClient()

    func fetchTopArticles() async throws -> [HNArticle] {
        var components = URLComponents()
        components.scheme = "https"
        components.host = "hn.algolia.com"
        components.path = "/api/v1/search"
        components.queryItems = [
            URLQueryItem(name: "tags", value: "front_page")
        ]

        guard let url = components.url else {
            throw APIError.invalidURL
        }

        let response: HNResponse = try await client.get(from: url)

        return response.hits
    }
}
