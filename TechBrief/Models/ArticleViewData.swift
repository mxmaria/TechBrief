//
//  ArticleViewData.swift
//  TechBrief
//
//  Created by Maria on 14.11.2025.
//

import Foundation

struct ArticleViewData: Identifiable, Hashable {
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

