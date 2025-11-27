//
//  ArticleViewData.swift
//  TechBrief
//
//  Created by Maria on 14.11.2025.
//

import Foundation

struct ArticleViewData: Identifiable, Hashable, Codable {
    let id: String
    let title: String
    let source: String
    let timeAgo: String
    let url: URL?
    var isSaved: Bool

    init(
        id: String,
        title: String,
        source: String,
        timeAgo: String,
        url: URL?,
        isSaved: Bool = false
    ) {
        self.id = id
        self.title = title
        self.source = source
        self.timeAgo = timeAgo
        self.url = url
        self.isSaved = isSaved
    }
}


extension ArticleViewData {
    init(from dev: DevToArticle) {
        self.init(
            id: String(dev.id),
            title: dev.title,
            source: "Dev.to",
            timeAgo: dev.readable_publish_date ?? "",
            url: URL(string: dev.url),
            isSaved: false
        )
    }
}
