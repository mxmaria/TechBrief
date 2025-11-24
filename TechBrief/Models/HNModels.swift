//
//  HNModels.swift
//  TechBrief
//
//  Created by Maria on 14.11.2025.
//

import Foundation

struct HNArticle: Decodable, Identifiable {
    let id: String
    let title: String
    let url: String?
    let author: String
    let createdAt: String

    enum CodingKeys: String, CodingKey {
        case id = "objectID"
        case title
        case url
        case author
        case createdAt = "created_at"
    }
}

struct HNResponse: Decodable {
    let hits: [HNArticle]
}


extension HNArticle {
    func toViewData() -> ArticleViewData {
        ArticleViewData(
            id: id,
            title: title,
            source: "Hacker News",
            timeAgo: Self.timeAgo(from: createdAt),
            url: URL(string: url ?? "")
            // isSaved uses default = false
        )
    }

    private static func timeAgo(from isoString: String) -> String {
        let formatter = ISO8601DateFormatter()
        guard let date = formatter.date(from: isoString) else { return "" }

        let seconds = Date().timeIntervalSince(date)
        let minutes = Int(seconds / 60)
        let hours = minutes / 60
        let days = hours / 24

        if minutes < 1 { return "now" }
        if minutes < 60 { return "\(minutes)m" }
        if hours < 24 { return "\(hours)h" }
        return "\(days)d"
    }
}

